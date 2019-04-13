import './main.css';
import {Elm} from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

function fetchTest() {
  const obj = {
    query: 'query { contriview(username: "k-nasa") { sumContributions }}',
  };
  const method = 'POST';
  const body = JSON.stringify(obj);
  const headers = {
    Accept: 'application/json',
    'content-type': 'application/json',
  };
  fetch('http://127.0.0.1:8080/graphql', {
    method,
    headers,
    body,
  })
    .then(res => res.json())
    .then(console.log)
    .catch(console.error);
}

fetchTest();

Elm.Main.init({
  node: document.getElementById('root'),
});

registerServiceWorker();
