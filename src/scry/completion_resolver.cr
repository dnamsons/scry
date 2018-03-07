module Scry
  class CompletionResolver
    def initialize(@id : Int32, @completionItem : CompletionItem)
    end

    def run
      data = @completionItem.data
      case data
      when RequireModuleContextData
        file = File.new data.path
        doc = file.each_line.first(5).join("\n")
        @completionItem.documentation = MarkupContent.new("markdown", "```crystal\n#{doc}\n```")
        @completionItem
      when MethodCallContextData
        file = File.new data.path
        line = data.location.not_nil!.split(":")[1].to_i
        lines = file.each_line.first(line-1).to_a.reverse.take_while(&.match /^\s*#/).map{|e| e.gsub(/^\s*#/, "") }.reverse.join("\n")
        @completionItem.documentation =  MarkupContent.new("markdown",  lines)
        @completionItem
      else
        @completionItem
      end
    end
  end
end
