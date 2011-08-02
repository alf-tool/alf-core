task :"gh-pages" do
  require 'fileutils'
  require 'wlang'
  require 'alf'
  require 'redcarpet'

  indir  = File.expand_path('../gh-pages', __FILE__)
  outdir = File.expand_path('../../doc/gh-pages', __FILE__)

  # Remove everything
  FileUtils.rm_rf File.join(outdir, "*")

  # copy assets
  FileUtils.cp_r File.join(indir, "no-analytics.html"), outdir
  FileUtils.cp_r File.join(indir, "css"), outdir
  FileUtils.cp_r File.join(indir, "images"), outdir

  # launch wlang on main template
  puts WLang::file_instantiate File.join(indir, 'main.wtpl'), {
    :version => Alf::VERSION,
    :outdir  => outdir,
    :main    => Alf::Command::Main,
    :pages   => Dir[File.join(indir, 'pages', '*.md')].to_a
  }
end
