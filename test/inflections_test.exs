defmodule InflectionsTest do
    use ExUnit.Case
    doctest Inflections

    test "should return en inflector or create new one if not present" do
        assert Inflections.get() == %Inflector{}
        assert Inflections.get(:en) == %Inflector{}
        assert Inflections.get(:es) == %Inflector{}
    end
    test "should update en inflector" do
        Inflections.set(:en, nil)
        assert Inflections.get(:en) == nil
        Inflections.set(:en, %Inflector{})
        assert Inflections.get(:en) == %Inflector{}
    end
    test "should return the default locale" do
        assert Inflections.default_locale() == :en
        assert Inflections.default_locale(:es) == :es
        assert Inflections.default_locale() == :es
    end
end
