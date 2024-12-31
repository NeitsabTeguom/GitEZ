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

## Integrating the project's `.bashrc`

To use this project's custom aliases and scripts, you can include the project's `.bashrc` file in your personal `~/.bashrc` file.

1. **Locate the project's `.bashrc` file**  
   Once the project is cloned, the `.bashrc` file will be available at the root of the project directory.
   Make sure to note the path where you cloned this project.

2. **Edit your user `~/.bashrc` file**  
   Open your `~/.bashrc` file on your user directory with a text editor, such as `nano` or `vim`:
   ```bash
   nano ~/.bashrc
   ```
   It could be `~/.bash_profile` or `~/.profile`.

3. **Add the following lines to the end of the `~/.bashrc` file**
   Replace `/path/to/project` with the absolute path where you cloned the project.
   ```bash
   if [ -f /path/to/project/.bashrc ]; then
       . /path/to/project/.bashrc
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
   ```
   or
   ```bash
   source ~/.profile
   ```