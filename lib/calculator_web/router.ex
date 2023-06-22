defmodule CalculatorWeb.Router do
  use CalculatorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CalculatorWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", CalculatorWeb do
    pipe_through :browser

    live "/", MainLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", CalculatorWeb do
  #   pipe_through :api
  # end
end
