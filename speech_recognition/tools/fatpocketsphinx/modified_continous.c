/* -*- c-basic-offset: 4; indent-tabs-mode: nil -*- */
/* ====================================================================
 * Copyright (c) 1999-2010 Carnegie Mellon University.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * This work was supported in part by funding from the Defense Advanced
 * Research Projects Agency and the National Science Foundation of the
 * United States of America, and the CMU Sphinx Speech Consortium.
 *
 * THIS SOFTWARE IS PROVIDED BY CARNEGIE MELLON UNIVERSITY ``AS IS'' AND
 * ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL CARNEGIE MELLON UNIVERSITY
 * NOR ITS EMPLOYEES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ====================================================================
 *
 */
/*
 * continuous.c - Simple pocketsphinx command-line application to test
 *                both continuous listening/silence filtering from microphone
 *                and continuous file transcription.
 */

/*
 * This is a simple example of pocketsphinx application that uses continuous listening
 * with silence filtering to automatically segment a continuous stream of audio input
 * into utterances that are then decoded.
 *
 * Remarks:
 *   - Each utterance is ended when a silence segment of at least 1 sec is recognized.
 *   - Single-threaded implementation for portability.
 *   - Uses audio library; can be replaced with an equivalent custom library.
 */

/* fatpocketsphinx_continuous
 *
 * Slightly adopted version of the original code
 *
 * - Optimized output for processing via pipes
 * - Show partial hypotheses
 * - Reduced silence length required for utterance end
 * - Removed microphone support
 * - Removed Windows Code
*/

#include <stdio.h>
#include <string.h>

#include <signal.h>
#include <setjmp.h>
#include <sys/types.h>
#include <sys/time.h>

#include <sphinxbase/err.h>
#include <sphinxbase/ad.h>
#include <sphinxbase/cont_ad.h>

#include "pocketsphinx.h"

static const arg_t cont_args_def[] = {
    POCKETSPHINX_OPTIONS,
    /* Argument file. */
    { "-argfile",
      ARG_STRING,
      NULL,
      "Argument file giving extra arguments." },
    { "-infile",
      ARG_STRING,
      NULL,
      "Audio file to transcribe." },
    { "-time",
      ARG_BOOLEAN,
      "no",
      "Print word times in file transcription." },
    CMDLN_EMPTY_OPTION
};

static ps_decoder_t *ps;
static cmd_ln_t *config;
static FILE* rawfd;

static int32
ad_file_read(ad_rec_t * ad, int16 * buf, int32 max)
{
    size_t nread;

    nread = fread(buf, sizeof(int16), max, rawfd);

    return (nread > 0 ? nread : -1);
}

static void
print_word_times(int32 start)
{
	ps_seg_t *iter = ps_seg_iter(ps, NULL);

	while (iter != NULL) {
		int32 sf, ef, pprob;
		float conf;

		ps_seg_frames (iter, &sf, &ef);
		pprob = ps_seg_prob (iter, NULL, NULL, NULL);
		conf = logmath_exp(ps_get_logmath(ps), pprob);
		printf ("= timed_word | %s | %f %f %f\n", ps_seg_word (iter), (sf + start) / 100.0, (ef + start) / 100.0, conf);
		iter = ps_seg_next (iter);
	}
}

/*
 * Continuous recognition from a file
 */
static void
recognize_from_file() {
    cont_ad_t *cont;
    ad_rec_t file_ad = {0};
    int16 adbuf[4096];
    const char* hyp;
    const char* uttid;
    int32 k, ts, start;

    char waveheader[44];

    if ((rawfd = fopen(cmd_ln_str_r(config, "-infile"), "rb")) == NULL) {
	    E_FATAL_SYSTEM("Failed to open file '%s' for reading",
			cmd_ln_str_r(config, "-infile"));
    }

    fread(waveheader, 1, 44, rawfd);

    file_ad.sps = (int32)cmd_ln_float32_r(config, "-samprate");
    file_ad.bps = sizeof(int16);

    if ((cont = cont_ad_init(&file_ad, ad_file_read)) == NULL) {
        E_FATAL("Failed to initialize voice activity detection\n");
    }

    if (cont_ad_calib(cont) < 0)
        E_INFO("Using default voice activity detection\n");

    rewind (rawfd);

    for (;;) {

	    while ((k = cont_ad_read(cont, adbuf, 4096)) == 0);

        if (k < 0)
    	    break;

        if (ps_start_utt(ps, NULL) < 0)
            E_FATAL("ps_start_utt() failed\n");

        ps_process_raw(ps, adbuf, k, FALSE, FALSE);

        hyp = ps_get_hyp(ps, NULL, &uttid);
        printf("= partial_hypothese | %s: %s\n", uttid, hyp);
        fflush(stdout);

        ts = cont->read_ts;
        start = ((ts - k) * 100.0) / file_ad.sps;

        for (;;) {
            if ((k = cont_ad_read(cont, adbuf, 4096)) < 0)
            	break;

            if (k == 0) {
                /*
                 * No speech data available; check current timestamp with most recent
                 * speech to see if more than 1 sec elapsed.  If so, end of utterance.
                 */

                if ((cont->read_ts - ts) > 2000) {
                  printf("= utterance_end | %i\n", (cont->read_ts - ts) );
                  break;
                }
            } else {
                /* New speech data received; note current timestamp */
                ts = cont->read_ts;
            }

            ps_process_raw(ps, adbuf, k, FALSE, FALSE);

            hyp = ps_get_hyp(ps, NULL, &uttid);
            printf("= partial_hypothese | %s: %s\n", uttid, hyp);
            fflush(stdout);
        }

        ps_end_utt(ps);

        if (cmd_ln_boolean_r(config, "-time")) {
	        print_word_times(start);

          printf("= continue\n");
          fflush(stdout);

          fgetc( stdin );

        } else {
          hyp = ps_get_hyp(ps, NULL, &uttid);
          printf("= final_hypothese | %s: %s\n\n\n", uttid, hyp);
        }

        fflush(stdout);
    }

    cont_ad_close(cont);
    fclose(rawfd);
}

int
main(int argc, char *argv[])
{
    char const *cfg;

    if (argc == 2) {
        config = cmd_ln_parse_file_r(NULL, cont_args_def, argv[1], TRUE);
    } else {
        config = cmd_ln_parse_r(NULL, cont_args_def, argc, argv, FALSE);
    }

    if (config && (cfg = cmd_ln_str_r(config, "-argfile")) != NULL) {
        config = cmd_ln_parse_file_r(config, cont_args_def, cfg, FALSE);
    }

    if (config == NULL)
        return 1;

    ps = ps_init(config);

    if (ps == NULL)
        return 1;

    E_INFO("%s COMPILED ON: %s, AT: %s\n\n", argv[0], __DATE__, __TIME__);

    if (cmd_ln_str_r(config, "-infile") != NULL) {
      recognize_from_file();
    }

    ps_free(ps);
    return 0;
}
