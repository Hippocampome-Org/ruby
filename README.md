### Requirements
To install and run this code requires:

- git
- Ruby (v.1.9 or greater)
- MySQL

The rest of the dependencies should be handled by the install script.  It has only been tested on Mac OS X, but it probably works on Linux too.

### Installation
Go to the directory in which you'd like to install the Hippocampome building code  and run

    git clone https://github.com/smackesey/hippocampome.git
    chmod +x hippocampome/install.sh
    hippocampome/install.sh

This will install several gems and clone some git repositories to the working directory.

### Source Data
In order for the Hippocampome to be built, a directory containing the source spreadsheets must be provided.  These spreadsheets must have particular names:

- Type summary (STM version): `type.csv`
- Article list (STM version): `article.csv`
- Morphological reference list: `morph_fragment.csv`
- Marker reference list: `marker_fragment.csv`
- Packet notes list: `packet_notes.csv`
- Figure list: `figure.csv`
- Main marker spreadsheet: `markerdata.csv`
- Main electrophysiology spreadsheet: `epdata.csv`
- Main hippocampome spreadsheet: `hc_main.csv`
- Known connections spreadsheet: `known_connections.csv`

In addition, this directory should contain a subdirectory holding the actual packet notes.  This should be named `packet_notes` and should contain a series of text files named `<typeId>.txt` containing the notes for the corresponding type.  For example, `1000.txt` contains the notes for DG granule cells.

### Configuration
Before running the build script, it's necessary to configure a few things.  Configuration is done in the `config.rb` file found in the root directory of the hippocampome repository.  Do the following:

- Set the values of `DB_NAME`, `DB_USERNAME`, and `DB_PASSWORD` to appropriate values for your MySQL installation.  `DB_NAME` is the name of the database that holds the Hippocampome.
- Change the value of `SOURCE_DATA_DIRECTORY` to the directory containing the source spreadsheets.  You can ignore `EXTERNAL_SOURCE_DATA_DIRECTORY`

In addition, you may need to run `export DYLD_LIBRARY_PATH=/usr/local/mysql/lib/` in the shell before running the build script.  Try this if running the script throws an error concerning MySQL libraries.  If you are going to rebuilding the Hippocampome frequently, you may wish to put this in your shell startup file (`.bashrc`, `.zshrc`, etc)

### Building the Hippocampome
If you have done all of the above, you should be able to build the Hippocampome!  Go into the root directory of the hippocampome repository and run `bin/build`.  Using the following command line flags perform some actions before building:

- c: clear the error logs
- e: empty the database
- v: will include some MySQL views in the build.  VERY useful if you are going to be writing queries directly.

...good luck
