module Alf
  def self.markdown(md)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(md)
  end
end

task :"gh-pages" do
  $:.unshift File.expand_path('../../lib', __FILE__)
  require 'fileutils'
  require 'wlang'
  require 'wlang/ext/hash_methodize'
  require 'alf'
  require 'bluecloth'
  require 'redcarpet'

  indir  = File.expand_path('../../doc/gh-pages', __FILE__)
  outdir = File.expand_path('../../doc/deploy-gh-pages', __FILE__)

  # Remove everything
  FileUtils.rm_rf outdir
  FileUtils.mkdir_p outdir

  # copy assets
  FileUtils.cp_r  File.join(indir, "no-analytics.html"), outdir
  FileUtils.cp_r  File.join(indir, "index.html"), outdir
  FileUtils.cp_r  File.join(indir, "css"), outdir
  FileUtils.cp_r  File.join(indir, "downloads"), outdir
  FileUtils.cp_r  File.join(indir, "js"), outdir
  FileUtils.cp_r  File.join(indir, "images"), outdir

  html    = File.join(indir, 'templates', "html.wtpl")
  context = {
    :version => Alf::Core::VERSION,
    :outdir  => outdir,
    :main    => Alf::Shell::Main
  }

  static = lambda{|entry|
    FileUtils.mkdir File.join(outdir, entry)
    ctx = context.merge(:prefix  => "..", :entry => entry.to_sym)
    Dir[File.join(indir, entry, '*.md')].each do |file|
      md     = File.read(file)
      title  = md.split("\n").first[3..-1].gsub("&mdash;", "-")
      text   = Alf.markdown(md)
      target = File.join(outdir, entry, "#{File.basename(file, ".md")}.html")
      File.open(target, "w") do |io|
        ctx2 = ctx.merge(:text => text, :title => title)
        io << WLang.file_instantiate(html, ctx2)
      end
    end
  }

  ["overview", "shell", "ruby", "devel", "use-cases"].each do |f|
    static.call(f)
  end

  ["shell", "ruby"].each do |entry|
    Alf::Shell::Main.subcommands.each do |sub|
      ctx    = context.merge(:prefix  => "..", :entry => entry.to_sym)
      target = File.join(outdir, entry, "#{sub.command_name}.html")
      File.open(target, "w") do |io|
        ctx2 = ctx.merge(:operator => sub,
                         :title => "Alf in #{entry.capitalize}: #{sub.command_name}")
        io << WLang.file_instantiate(html, ctx2)
      end
    end
  end

end
