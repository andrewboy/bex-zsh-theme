# bex-zsh-theme

## install

1. install ZSH

1. install oh-my-zsh

    ```shell
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    ```

1. copy

    ```shell
    cp bex.zsh-theme $ZSH_CUSTOM/themes
    ```

1. set

    ```shell
    nano ~/.zshrc
    # set this
    # ZSH_THEME="bex"
    ```

1. autocomplete

    ```shell
    sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    nano ~/.zshrc
    # set this
    # plugins=(
    #   ...
    #   zsh-autosuggestions
    # )
    ```

1. syntax highlighting

    ```shell
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    nano ~/.zshrc
    # set this
    # plugins=(
    #   ... 
    #   zsh-syntax-highlighting
    # )
    ```

1. make it default shell (optional)

    ```shell
    sudo chsh -s $(which zsh)
    ```
