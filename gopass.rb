class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams."
  homepage "https://www.justwatch.com/gopass/"
  url "https://github.com/dominikschulz/gopass/archive/v1.7.0.tar.gz"
  head "https://github.com/dominikschulz/gopass.git"
  version "1.7.0"
  sha256 "01bf9e50f8132e5d8b7755bc29767fd70a28ab6c810be26dd9e0f15841b646ee"
  
  depends_on "git"
  depends_on "gnupg"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/justwatchcom/gopass").install buildpath.children
    
    cd "src/github.com/justwatchcom/gopass" do
      ENV["PREFIX"] = prefix
      system "make", "install"
    end
    
    system bin/"gopass completion bash > bash_completion.bash"
    system bin/"gopass completion zsh > zsh_completion.zsh"
    bash_completion.install "bash_completion.bash"
    zsh_completion.install "zsh_completion.zsh"
  end

  def caveats; <<-EOS.undent
    Gopass has been installed, have fun!
    If upgrading from `pass`, everything should work as expected.
    If installing from scratch, you need to either initialize a new repository now...
      gopass init
    ...or clone one from a source:
      gopass clone git@code.example.com:example/pass.git
    In order to use the great autocompletion features (they're helpful with gopass),
    please make sure you have autocompletion for homebrew enabled:
      https://github.com/bobthecow/git-flow-completion/wiki/Install-Bash-git-completion
    More information:
      https://www.justwatch.com/gopass
      https://github.com/justwatchcom/gopass/README.md
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")
  end
end
