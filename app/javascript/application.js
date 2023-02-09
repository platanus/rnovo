import { createApp } from 'vue';
import App from './components/app.vue';
import BaseButton from './components/base-button.vue';
import BaseInput from './components/base-input.vue';
import BaseLabel from './components/base-label.vue';
import TermSearch from './components/term-search.vue';
import './css/application.css';

document.addEventListener('DOMContentLoaded', () => {
  const globalComponents = {
    BaseButton,
    BaseInput,
    BaseLabel,
  };

  const app = createApp({
    components: { App, TermSearch },
  });

  Object.entries(globalComponents).forEach(([name, component]) => {
    app.component(name, component);
  });

  app.mount('#vue-app');

  return app;
});
