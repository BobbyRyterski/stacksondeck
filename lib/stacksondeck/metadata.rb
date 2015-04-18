# StacksOnDeck a.k.a. SOD. SoUlJa BoY TeLlEm DoT cOm sHe ThIrStY.
module StacksOnDeck
  # Officially, it's "stacksondeck" (but whatever)
  NAME     = 'stacksondeck'

  # A quick summary for use in the command-line interface
  SUMMARY  = %q.Stupid simple Chef-Rundeck integration.

  # Take credit for your work
  AUTHOR   = 'Sean Clemmer'

  # Take responsibility for your work
  EMAIL    = 'sczizzo@gmail.com'

  # Like the MIT license, but even simpler
  LICENSE  = 'ISC'

  # Where you should look first
  HOMEPAGE = 'https://github.com/sczizzo/stacksondeck'

  # Project root
  ROOT = File.join File.dirname(__FILE__), '..', '..'

  # Pull the project version out of the VERSION file
  VERSION = File.read(File.join(ROOT, 'VERSION')).strip

  # Bundled extensions
  TRAVELING_RUBY_VERSION = '20150210-2.2.0'
  THIN_VERSION = '1.6.3'
  EM_VERSION = '1.0.4'

  # Big money
  ART = <<-'EOART'
     $$$$$$\   $$$$$$\  $$$$$$$\
    $$  __$$\ $$  __$$\ $$  __$$\
    $$ /  \__|$$ /  $$ |$$ |  $$ |
    \$$$$$$\  $$ |  $$ |$$ |  $$ |
     \____$$\ $$ |  $$ |$$ |  $$ |
    $$\   $$ |$$ |  $$ |$$ |  $$ |
    \$$$$$$  | $$$$$$  |$$$$$$$  |
     \______/  \______/ \_______/
  EOART
end