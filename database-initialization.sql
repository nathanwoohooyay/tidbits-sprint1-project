DROP TABLE IF EXISTS client_trades;
DROP TABLE IF EXISTS client_subscriptions;
DROP TABLE IF EXISTS model_portfolio_holdings;
DROP TABLE IF EXISTS clients_holdings;
DROP TABLE IF EXISTS model_portfolios;
DROP TABLE IF EXISTS instruments;
DROP TABLE IF EXISTS clients;

CREATE TABLE clients (
    client_id INT PRIMARY KEY,
    name TEXT NOT NULL,
    advisor_id INT NOT NULL
);

CREATE TABLE instruments (
    instrument_id INT PRIMARY KEY,
    ticker TEXT NOT NULL UNIQUE,
        CHECK (LENGTH(ticker) BETWEEN 1 AND 8),
    name TEXT NOT NULL
);

CREATE TABLE model_portfolios (
    model_portfolio_id INT PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE clients_holdings (
    client_id INT NOT NULL REFERENCES clients(client_id),
    instrument_id INT NOT NULL REFERENCES instruments(instrument_id),
    quantity NUMERIC(10,2) NOT NULL,
        CHECK (quantity >= 0),
    as_of_date DATE NOT NULL,
    PRIMARY KEY (client_id, instrument_id, as_of_date)
);

CREATE TABLE model_portfolio_holdings (
    model_portfolio_id INT NOT NULL REFERENCES model_portfolios(model_portfolio_id),
    instrument_id INT NOT NULL REFERENCES instruments(instrument_id),
    target_weight_pct NUMERIC(5,2) NOT NULL,
        CHECK (target_weight_pct BETWEEN 0 AND 100),
    PRIMARY KEY (model_portfolio_id, instrument_id)
);

CREATE TABLE client_subscriptions (
    client_id INT NOT NULL REFERENCES clients(client_id),
    model_portfolio_id INT NOT NULL REFERENCES model_portfolios(model_portfolio_id),
    subscribed_date DATE NOT NULL,
    PRIMARY KEY (client_id, model_portfolio_id)
);

CREATE TABLE client_trades (
    trade_id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(client_id),
    instrument_id INTEGER NOT NULL REFERENCES instruments(instrument_id),
    trade_type TEXT NOT NULL CHECK (trade_type IN ('BUY', 'SELL')),
    quantity NUMERIC(14,4) NOT NULL CHECK (quantity > 0),
    price NUMERIC(14,4) NOT NULL CHECK (price > 0),
    trade_date DATE NOT NULL
);

CREATE INDEX idx_clients_advisor_id ON clients(advisor_id);
CREATE INDEX idx_clients_holdings_client_id ON clients_holdings(client_id);
CREATE INDEX idx_clients_holdings_instrument_id ON clients_holdings(instrument_id);
CREATE INDEX idx_model_portfolio_holdings_model_portfolio_id ON model_portfolio_holdings(model_portfolio_id);
CREATE INDEX idx_model_portfolio_holdings_instrument_id ON model_portfolio_holdings(instrument_id);
CREATE INDEX idx_client_subscriptions_client_id ON client_subscriptions(client_id);
CREATE INDEX idx_client_subscriptions_model_portfolio_id ON client_subscriptions(model_portfolio_id);
CREATE INDEX idx_instruments_ticker ON instruments(ticker);
CREATE INDEX idx_client_trades_client_id ON client_trades(client_id);
CREATE INDEX idx_client_trades_instrument_id ON client_trades(instrument_id);

