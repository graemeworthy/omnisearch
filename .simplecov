SimpleCov.start do
    add_filter '/spec/'
    add_group "Indexes", "/lib/omni_search/indexes"
    add_group "Engines", "/lib/omni_search/engines"
    add_group "Cache",   "/lib/omni_search/cache"
end
