defmodule InflectionsTest do
    use ExUnit.Case
    doctest Inflections

    test "should return en inflector or create new one if not present" do
        assert Inflections.get(:en) == %Inflector{}
    end
    test "should return the default locale" do
        assert Inflections.default_locale() == :en
    end
end
