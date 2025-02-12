# Git EZ

A collection of Bash aliases scripts to automate Git commands.

## Included aliases scripts
- `gez-fs` : Start a new feature.
- `gez-ff` : Finalize a feature.
- `gez-bs` : Start a bugfix.
- `gez-bf` : Finalize a bugfix.
- `gez-hs` : Start a hotfix.
- `gez-hf` : Finalize a hotfix.
- `gez-rs` : Start a release.
- `gez-rf` : Finalize a release.
- `gez-f`  : Finish the current branch.
- `gez-s`  : Quick save (add + commit + push).
- `gez-gm` : Get the master name branch.

## Installation

Clone this repository :
   ```bash
   git clone https://github.com/NeitsabTeguom/GitEZ.git
   ```

   For Windows dont forget to install [Git bash](https://git-scm.com/downloads).

## Integrating the GitEZ `.bashrc`

To use GitEZ's custom aliases and scripts, you can include GitEZ `.bashrc` file in your personal `~/.bashrc` file.

1. **Locate the GitEZ `.bashrc` file**  

   Once GitEZ is cloned, the `.bashrc` file will be available at the root of GitEZ directory.

   Make sure to note the path where you cloned GitEZ !

2. **Edit your user `~/.bashrc` file**  

   Open your `~/.bashrc` file on your user directory with a text editor, such as `nano` or `vim` (or Notpad in Windows):
   ```bash
   nano ~/.bashrc
   ```
   It could be `~/.bash_profile` or `~/.profile`.

3. **Add the following lines to the end of the `~/.bashrc` file**

   Replace `/path/to/GitEZ` with the absolute path where you cloned GitEZ.
   ```bash
   if [ -f /path/to/GitEZ/.bashrc ]; then
       . /path/to/GitEZ/.bashrc
   fi
   ```

   For windows do not forget the disk drive letter :
   ```bash
   if [ -f /c/path/to/GitEZ/.bashrc ]; then
       . /c/path/to/GitEZ/.bashrc
   fi
   ```

4. **Reload your Bash configuration**
   To apply the changes immediately, run the following command:
   ```bash
   source ~/.bashrc
   ```
   or
   ```bash
   source ~/.bash_profile
   ```
   or
   ```bash
   source ~/.profile
   ```