### 安装

fir-cli 使用 Ruby 构建, 无需编译, 只要安装相应 gem 即可.

```sh
$ ruby -v # > 2.6.1
$ gem install fir-cli
```

#### 常见的安装问题

- ruby 要求最低版本为 2.3

- 使用系统自带的 Ruby 安装, 需确保 ruby-dev 已被正确的安装:

  ```sh
  $ xcode-select --install        # OS X 系统
  $ sudo apt-get install ruby-dev # Linux 系统
  ```

- 出现 `Permission denied` 相关错误:

  在命令前加上 `sudo`

- 出现 `Gem::RemoteFetcher::FetchError` 相关错误:

  更换 Ruby 的源(由于国内网络原因, 你懂的), 并升级下系统自带的 gem

  ```sh
  $ gem sources --remove https://rubygems.org/
  $ gem sources -a https://gems.ruby-china.com/
  $ gem sources -l
  *** CURRENT SOURCES ***

  https://gems.ruby-china.com
  # 请确保只有 gems.ruby-china.com, 如果有其他的源, 请 remove 掉

  gem update --system
  gem install fir-cli
  ```

- Mac OS X 10.11 以后的版本, 由于10.11引入了 `rootless`, 无法直接安装 fir-cli, 有以下三种解决办法:

  1\. 使用 [Homebrew](http://brew.sh/) 及 [RVM](https://rvm.io/) 安装 Ruby, 再安装 fir-cli(推荐)

  ```sh
  # Install Homebrew:
  $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # Install RVM:
  $ \curl -sSL https://get.rvm.io | bash -s stable --ruby

  $ gem install fir-cli
  ```

  2\. 指定 fir-cli 中 bin 文件的 PATH

  ```sh
  $ export PATH=/usr/local/bin:$PATH;gem install -n /usr/local/bin fir-cli
  ```

  3\. 重写 Ruby Gem 的 bindir

  ```sh
  $ echo 'gem: --bindir /usr/local/bin' >> ~/.gemrc
  $ gem install fir-cli
  ```
