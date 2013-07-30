## LiveTranscriber

LiveTranscriber is an open-source, semi-automated transcription platform combining automated speech recognition (ASR) and human-made corrections/reviewing.

The reviewed and corrected transcript is then used to improve the acoustic and language models.

## Screenshots

![Transcribe without Typing](http://skpvox.github.io/LiveTranscriber/screenshots/transcribe_without_typing.png)

![Transcriber Screenshot](http://skpvox.github.io/LiveTranscriber/screenshots/transcriber.png)


## Video Demonstration

Feel free to watch the [YouTube Video](http://www.youtube.com/watch?v=EA9yWoyhHvM) for a short demo.

You should also watch the video that layed the groundwork for this project:

Peter Grasch's [Simon Dictation Prototype Video](http://www.youtube.com/watch?v=uItCqkpMU_k)

## About

Transcribing is a tedious and work-intensive task. Most people hate to do it.

Computers don't mind doing it, but they make mistakes.

We want to make it more fun, by letting the computer do the heavy-lifting while you just correct the mistakes.

This way you train the computer to recognize words better.

Our goal is to improve open-source speech recognition. If you use this application you must give every transcription that you make with it back to the community.


## Installation

1. Install the requirements:
    * [Ruby 2.0+](http://www.ruby-lang.org/en/)
    * [RubyGems](http://rubygems.org/)
    * [Bundler](http://bundler.io/)
    * [SoX](http://sox.sourceforge.net/)

2. Fetch the git repository

    	  git clone git://github.com/skpvox/LiveTranscriber

3. Install all gems via bundler

	      bundle install

4. Compile `fatpocketsphinx_continuous`.
    * See `INSTALL` file under `speech_recognition/tools/fatpocketsphinx`

5. Download the language and acoustic model. Thanks to Peter Grasch for providing these:
    * [Language Model Download](http://files.kde.org/accessibility/Simon/lm/)
    * [Acoustic Model Download](http://files.kde.org/accessibility/Simon/am/)

6. Extract the speech models and save them like this:

        speech_recognition/models/hidden_markov_model/voxforge_en_sphinx.cd_cont_5000/
        speech_recognition/models/dictionary/essential_sane_65k.fullCased
        speech_recognition/models/language_model/ensemble_wiki_ng_se_so_subs_enron_congress_65k_pruned_huge_sorted_cased.lm.DMP

7. Setup the database by running:

        rake db:setup

8. Run Redis

        redis-server

9. Run the `puma` server to start the application

        puma

## Contributions

You are encouraged to contribute to this project.

Please take a look at our "Issues" page on GitHub.

## License

This project is licensed under the GNU Affaro GPL.

Any transcriptions made with this application must be shared with the community.
