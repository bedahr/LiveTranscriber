## LiveTranscriber

LiveTranscriber is an open-source, semi-automated transcription platform combining automated speech recognition (ASR) and human-made corrections/reviewing.

The reviewed and corrected transcript is then used to improve the acoustic and language models.

* TODO: Add Screenshot

## Video Demonstration

Feel free to watch the [YouTube Video](http://www.youtube.com/watch?v=EA9yWoyhHvM) for a short demo.

You should also watch the video that layed the groundwork for this project:

Peter Grasch's [Simon Dictation Prototype Video](http://www.youtube.com/watch?v=uItCqkpMU_k)

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

4. Compile `fatpocketsphinx`

     	 TODO: Add Instructions

5. Download the language and acoustic model. Thanks to Peter Grasch for providing these:
    * [Language Model Download](http://files.kde.org/accessibility/Simon/lm/)
    * [Acoustic Model Download](http://files.kde.org/accessibility/Simon/am/)

6. Extract the speech models and save them like this:

        speech_recognition/models/hmm/voxforge_en_sphinx.cd_cont_5000/
        speech_recognition/models/dict/essential-sane-65k.fullCased
        speech_recognition/models/lm/ensemble_wiki_ng_se_so_subs_enron_congress_65k_pruned_huge_sorted_cased.lm.DMP

7. Run it

     	 rails server

## Contributions

You are encouraged to contribute to this project.

Please take a look at our "Issues" page on GitHub.

## License

This project is licensed under the GNU Affaro GPL.

Any transcriptions made with this software must be shared with the community.
