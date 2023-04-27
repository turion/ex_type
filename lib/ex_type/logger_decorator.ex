defmodule ExType.LoggerDecorator do
  use Decorator.Define, [debug_log: 1, debug_log: 2]

  require Logger

  def debug_log(metadata, opts \\ [], body, context) do
    log_result = Keyword.get(opts, :log_result, false)
    quote do
      Logger.debug("""
        In: #{__ENV__.file}
        Called: #{Atom.to_string(unquote(context.name))}
        Metadata: #{inspect(unquote(metadata), pretty: true)}
      """)
      result = unquote(body)
      if unquote(log_result) do
        Logger.debug("""
          In: #{__ENV__.file}
          Call completed: #{Atom.to_string(unquote(context.name))}
          Result: #{inspect(result, pretty: true)}
        """)
      end
      result
    end
  end
end
