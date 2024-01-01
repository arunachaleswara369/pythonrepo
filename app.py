# app.py
from flask import Flask
from hydra import initialize, compose
from omegaconf import OmegaConf

app = Flask(__name__)

def load_config():
    with initialize(config_path="config"):
        config = compose(config_name="config")
    return config

config = load_config()

@app.route('/')
def hello_world():
    return config.message

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5003, debug=True)