defmodule Inflections do
    use Application
    use Supervisor

    defmodule Locales do

        def start_link() do
            Agent.start_link(fn -> %{} end, name: __MODULE__)
        end

        def get(locale) do
            locales = Agent.get(__MODULE__, fn(locales) ->
                if Map.has_key?(locales, locale) do
                    locales
                else
                    Map.put(locales, locale, Inflector.new())
                end
            end)
            Map.get(locales, locale)
        end
        def set(locale, inflector) do
            Agent.get_and_update(__MODULE__, fn(locales) ->
                {inflector, Map.put(locales, locale, inflector)}
            end)
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
            Agent.update(__MODULE__, fn(_) -> locale end)
            locale
        end
    end

    def get(locale) do
        Locales.get(locale)
    end
    def get(), do: get(default_locale())

    def set(locale, inflector) do
        Locales.set(locale, inflector)
    end

    def default_locale() do
        DefaultLocale.get()
    end
    def default_locale(locale) do
        DefaultLocale.set(locale)
    end

    def start(_type, _args) do
        Supervisor.start_link(__MODULE__, [])
    end

    def init([]) do
        children = [
            worker(DefaultLocale, []),
            worker(Locales, [])
        ]
        supervise(children, strategy: :one_for_one)
    end
end
