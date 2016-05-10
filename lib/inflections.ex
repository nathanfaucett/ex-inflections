defmodule Inflections do
    use Application
    use Supervisor

    defmodule Locales do

        def start_link() do
            Agent.start_link(fn -> %{} end, name: __MODULE__)
        end

        def get(locale) do
            Agent.get(__MODULE__, fn(locales) ->
                if Map.has_key?(locales, locale) do
                    Map.get(locales, locale)
                else
                    inflector = Inflector.new()
                    locales = Map.put(locales, locale, inflector)
                    inflector
                end
            end)
        end
        def set(locale, inflector) do
            Agent.update(__MODULE__, fn(locales) ->
                Map.put(locales, locale, inflector)
            end)
            inflector
        end
    end

    defmodule DefaultLocale do

        def start_link() do
            Agent.start_link(fn -> :en end, name: __MODULE__)
        end

        def get() do
            Agent.get(__MODULE__, fn(locale) -> locale end)
        end
        def set(locale) do
            Agent.update(__MODULE__, fn() -> locale end)
            locale
        end
    end

    def get(locale) do
        Locales.get(locale)
    end
    def set(locale, inflector) do
        Locales.set(locale, inflector)
    end

    def default_locale() do
        DefaultLocale.get()
    end
    def set_default_locale(locale) do
        DefaultLocale.get(locale)
    end

    def start(_type, _args) do
        children = [
            worker(DefaultLocale, []),
            worker(Locales, [])
        ]
        Supervisor.start_link(children, strategy: :one_for_one)
    end
end
