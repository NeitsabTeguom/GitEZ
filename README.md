# Git EZ Scripts

A collection of Bash scripts to automate Git commands.

## Included scripts
- `feature-start.sh` : Create a new feature.
- `feature-finish.sh` : Finalize a feature.
- `bugfix-start.sh` : Create a bugfix.
- `bugfix-finish.sh` : Finalize a bugfix.
- `hotfix-start.sh` : Create a hotfix.
- `hotfix-finish.sh` : Finalize a hotfix.
- `release-start.sh` : Create a release.
- `release-finish.sh` : Finalize a release.
- `finish.sh` : Finalize current branch.
- `push-all.sh` : Local changes and sending

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

2. **Edit your `~/.bashrc` file**  
   Open your `~/.bashrc` file with a text editor, such as `nano` or `vim`:
   ```bash
   nano ~/.bashrc
   ```
   
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