# TurbolinksPlug

This plug integrates [turbolinks](https://github.com/turbolinks/turbolinks) into your phoenix application.
Because turbolinks makes an xhr requests it cannot update browser URL on redirects without help from backend.
And that's exactly what this plug does. After each redirect initiated by turbolinks it sets `Turbolinks-Location` header to hint url.

## Installation

  1. Add `turbolinks_plug` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:turbolinks_plug, "~> 0.1.0"}]
    end
    ```

  2. Add plug to your pipeline in `web/router.ex`
  ```elixir
    pipeline :browser do
      ...
      plug TurbolinksPlug
    end
  ```
