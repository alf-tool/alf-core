task :"gh-pages" do
  require 'fileutils'
  require 'wlang'
  require 'wlang/ext/hash_methodize'
  require 'alf'
  require 'bluecloth'
  require 'redcarpet'

  indir  = File.expand_path('../../doc/gh-pages', __FILE__)
  outdir = File.expand_path('../../doc/deploy-gh-pages', __FILE__)

  # Remove everything
  Dir[File.join(outdir, '*')].each do |f|
    FileUtils.rm_rf f
  end

  # copy assets
  FileUtils.cp_r  File.join(indir, "no-analytics.html"), outdir
  FileUtils.cp_r  File.join(indir, "index.html"), outdir
  FileUtils.cp_r  File.join(indir, "css"), outdir
  FileUtils.cp_r  File.join(indir, "images"), outdir

  html    = File.join(indir, 'templates', "html.wtpl")
  context = {
    :version => Alf::VERSION,
    :outdir  => outdir,
    :main    => Alf::Command::Main
  }

  static = lambda{|entry|
    FileUtils.mkdir File.join(outdir, entry)
    ctx = context.merge(:prefix  => "..", :entry => entry.to_sym)
    Dir[File.join(indir, entry, '*.md')].each do |file|
      md     = File.read(file)
      title  = md.split("\n").first[3..-1]
      text   = Redcarpet.new(md).to_html
      target = File.join(outdir, entry, "#{File.basename(file, ".md")}.html")
      File.open(target, "w") do |io|
        ctx2 = ctx.merge(:text => text, :title => title)
        io << WLang.file_instantiate(html, ctx2)
      end
    end
  }
  static.call("overview")
  static.call("shell")
  static.call("ruby")

  entry = "shell"
  Alf::Command::Main.subcommands.each do |sub| 
    ctx    = context.merge(:prefix  => "..", :entry => entry.to_sym)
    target = File.join(outdir, entry, "#{sub.command_name}.html")
    File.open(target, "w") do |io|
      ctx2 = ctx.merge(:operator => sub, :title => "Alf in Shell: #{sub.command_name}")
      io << WLang.file_instantiate(html, ctx2)
    end
  end

end
