
# dir-bookmark 🔖

A cli tool to bookmark directories and directory history.  


Heavily inspired by [zoxide](https://github.com/ajeetdsouza/zoxide).  

Only test with Linux Ubuntu 20.04.5 LTS and WSL Ubuntu 20.04.2 LTS on Windows 10 x86_64.


## Features

- Bookmark directories
- Store history with custom cd like command
- Edit bookmark and history
- Smart bookmark

- [fzf](https://github.com/junegunn/fzf) bookmark and history


## Installation
Before install this tool, make sure to install:
- fzf: https://github.com/junegunn/fzf
After installing [fzf](https://github.com/junegunn/fzf) run the commands below in bash.

```bash
  git clone https://github.com/memoryInject/dir-bookmark.git ~/.local/share/dir-bookmark
  
  ~/.local/share/dir-bookmark/install.sh
```
### Manual installation
The `install.sh` script will add the lines in your `.bashrc` and `.zshrc`

```bash
# dir-bookmark
source '~/.local/share/dir-bookmark/main.sh'
alias s=__bm_main
alias sd='__bm_main cd'

```
You can add these lines manually in your `.bashrc` or `.zshrc` files.   
After sourcing your `.bashrc` or `.zshrc`, `s` and `sd` commands will be available.



## Usage/Examples
After successful installation, by default there will be `s` and `sd` command available in bash (unless you choose to change default commands at installation stage)    

#### Run help:

```bash
❯ s --help
bm 0.01.0
A directory bookmark tool and cd tool with some other cool stuff

Script usage:  __bm_main [Flags/Commands] [Options] [Path] ...

Flags/Commands:
      .                                                 Add current path to bookmark: '__bm_main .'
      a , -a , add, -add, --add-bookmark <path>         Add path to bookmark works with pipes too: 'pwd | __bm_main add'
      b , -b , --bookmark                               Select bookmark and cd to it, run without any flags/commads works as well: '__bm_main'
      l , -l , --list-history                           Select history from and cd to it
      e , -e , --edit, --edit-bookmark                  Edit bookmark in vim

      eh, -eh, --edit-bookmark                          Edit history in vim
      r , -r , --remove, --remove-bookmark              Remove an entry from bookmark

      rh, -rh, --remove-bookmark                        Remove an entry from history

      cd <path>                                         Same as cd except it will add visited path to history list and support pipe: '/home/mahesh | __bm_main cd -i'
      h , -h , --help                                   Show help
```

#### Add to bookmark:   
To add current directory just run `s .`     

Add any path run `s add <path>`

```bash
❯ s .
 
❯ s add ~/bash/

❯ s -add ~/bashh/
Not a valid directory!
```

#### Select bookmark and cd to it:
Run fzf for bookmark run `s`  
It shows new bookmarks at the top and old at bottom

```bash

❯ s
Bookmarks:
>   < 11/11
> /home/mahesh/bash/
  /home/mahesh/bash
  /home/mahesh/bash/dir-bookmark/dir-bookmark
  /home/mahesh/bash/cheat-sheet
  /home/mahesh/bash/dir-bookmark
  /usr/bin
╭─────────────────────────────────────────────────────────────────────────────────────╮
│ __pycache__/              dir-bookmark/                    kill_loop.sh             │
╰─────────────────────────────────────────────────────────────────────────────────────╯


```

#### Using history:


To get the histoy, first use `sd` command instead of `cd` in order to add directory history  
It works just like `cd` but it will add the path to an history list

```bash

❯ sd ansible

~/ansible
❯
```

To get all the history list on fzf run `s l` or `s -l` or `s --list-history`, **NOTE:** here use `s` **not** `sd`   
It shows new history at the top and old at bottom   
```bash
~/ansible

❯ s -l
Recent history:
> │ < 16/16
> /home/mahesh/ansible
  /home/mahesh/bash
  /home/mahesh/bash/dir-bookmark
  /home/mahesh/bash/cheat-sheet
  /home/mahesh
  /home/mahesh/tmp

╭──────────────────────────────────────────────────────────────────────────────────────────────────╮
│ tmp/                                                                                             │
╰──────────────────────────────────────────────────────────────────────────────────────────────────╯

```

#### Remove an entry from the list:   
Remove an entry from bookmarks run `s r` or  `s -r` 
```bash
❯ s -r
Select a bookmark to remove <Esc> to cancel:
> │ < 11/11
> 11:/home/mahesh/bash/
  10:/home/mahesh/bash
  9:/home/mahesh/bash/dir-bookmark/dir-bookmark

  8:/home/mahesh/bash/cheat-sheet
  7:/home/mahesh/bash/dir-bookmark
  6:/usr/bin
  5:/home/mahesh
  4:/home/mahesh/c
  3:/home/mahesh/tmp/arc_pattern_python
```

Remove an entry from history run `s rh` or  `s -rh`
```bash
❯ s -rh
Select a history to remove <Esc> to cancel:
>   < 16/16
> 16:/home/mahesh/ansible
  15:/home/mahesh/bash
  14:/home/mahesh/bash/dir-bookmark
  13:/home/mahesh/bash/cheat-sheet
  12:/home/mahesh
  11:/home/mahesh/tmp
  10:/home/mahesh/Pictures
  9:/home/mahesh/Documents
  8:/home/mahesh/Desktop
``` 

#### Edit Bookmark and History:
Edit bookmark list run: `s e`, it will open in vim with bookmark_list.txt file   

Edit history list run: `s eh`, it will open in vim with history_list.txt file

**NOTE:** list file show old entires at top and new entries at the bottom.


## Alternatives
If you find that dir-bookmark doesn't quite satisfy your requirements, these may be a better fit:
- [zoxide](https://github.com/ajeetdsouza/zoxide/)
## Contributing

Contributions are always welcome!


Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.



## License


[MIT](https://choosealicense.com/licenses/mit/)


## Support

For support, email: msmahesh@live.com

More info: www.memoryinject.io


