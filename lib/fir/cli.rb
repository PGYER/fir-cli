# encoding: utf-8

module FIR
  class CLI < Thor
    class_option :token,   type: :string,  aliases: "-T", desc: "User's token at FIR.im"
    class_option :logfile, type: :string,  aliases: "-L", desc: "Path to writable logfile"
    class_option :verbose, type: :boolean, aliases: "-V", desc: "Show verbose", default: true
    class_option :quiet,   type: :boolean, aliases: "-q", desc: "Silence commands"
    class_option :help,    type: :boolean, aliases: "-h", desc: "Show this help message and quit"

    desc "build_ipa BUILD_DIR [options] [settings]", "Build iOS application (alias: 'b')."
    long_desc <<-LONGDESC
      `build_ipa` command will auto build your project/workspace to an ipa package
      and it also can auto publish your built ipa to FIR.im if use `-p` option.
      Internally, it use `xcodebuild` to accomplish these things, use `man xcodebuild` to get more information.

      Example:

      $ fir b <project dir> [-C <configuration>] [-t <target name>] [-o <ipa output dir>] [settings] [-c <changelog>] [-p -T <your token>]

      $ fir b <workspace dir> -w -s <scheme name> [-C <configuration>] [-t <target name>] [-o <ipa output dir>] [settings] [-c <changelog>] [-p -T <your token>]
    LONGDESC
    map ["b", "build"] => :build_ipa
    method_option :workspace,     type: :boolean, aliases: "-w", desc: "Set true/false if build workspace"
    method_option :scheme,        type: :string,  aliases: "-s", desc: "Set the scheme NAME if build workspace"
    method_option :configuration, type: :string,  aliases: "-C", desc: "Use the build configuration NAME for building each target"
    method_option :target,        type: :string,  aliases: "-t", desc: "Build the target specified by targetname"
    method_option :output,        type: :string,  aliases: "-o", desc: "IPA output path, the default is: BUILD_DIR/build_ipa"
    method_option :publish,       type: :boolean, aliases: "-p", desc: "Set true/false if publish to FIR.im"
    method_option :short,         type: :string,  aliases: "-s", desc: "Set custom short link if publish to FIR.im"
    method_option :changelog,     type: :string,  aliases: "-c", desc: "Set changelog if publish to FIR.im"
    def build_ipa *args
      prepare :build_ipa

      FIR.build_ipa(*args, options)
    end

    desc "info APP_FILE_PATH", "Show iOS/Android application's information, support ipa/apk file (aliases: 'i')."
    map "i" => :info
    method_option :all, type: :boolean, aliases: "-a", desc: "Show all information in application"
    def info *args
      prepare :info

      FIR.info(*args, options)
    end

    desc "publish APP_FILE_PATH", "Publish iOS/Android application to FIR.im, support ipa/apk file (aliases: 'p')."
    map "p" => :publish
    method_option :short,     type: :string, aliases: "-s", desc: "Set custom short link"
    method_option :changelog, type: :string, aliases: "-c", desc: "Set changelog"
    def publish *args
      prepare :publish

      FIR.publish(*args, options)
    end

    desc "login", "Login FIR.im (aliases: 'l')."
    map "l" => :login
    def login *args
      prepare :login

      token = options[:token] || args.first || ask("Please enter your FIR.im token:", :white, echo: true)
      FIR.login(token)
    end

    desc "upgrade", "Upgrade FIR-CLI and quit (aliases: u)."
    map "u" => :upgrade
    def upgrade
      prepare :upgrade
      say "✈ Upgrade FIR-CLI (use `gem install fir-cli --no-ri --no-rdoc`)"
      say `gem install fir-cli --no-ri --no-rdoc`
    end

    desc "version", "Show FIR-CLI version number and quit (aliases: v)"
    map ["v", "-v", "--version"] => :version
    def version
      say "✈ FIR-CLI #{FIR::VERSION}"
    end

    desc "help", "Describe available commands or one specific command."
    map Thor::HELP_MAPPINGS => :help
    def help command = nil, subcommand = false
      super
    end

    no_commands do
      def invoke_command command, *args
        FIR.logger       = options[:logfile] ? Logger.new(options[:logfile]) : Logger.new(STDOUT)
        FIR.logger       = Logger.new('/dev/null') if options[:quiet]
        FIR.logger.level = options[:verbose] ? Logger::INFO : Logger::ERROR
        super
      end
    end

    private

      def prepare task
        if options.help?
          help(task.to_s)
          raise SystemExit
        end
        $DEBUG = true if ENV["DEBUG"]
      end

  end
end
