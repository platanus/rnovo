import { createApp } from 'vue';
import { createI18n } from 'vue-i18n';
import { VueQueryPlugin } from '@tanstack/vue-query';
import App from './components/app.vue';
import BaseButton from './components/base-button.vue';
import BaseInput from './components/base-input.vue';
import BaseLabel from './components/base-label.vue';
import BaseMultiselect from './components/base-multiselect.vue';
import TermSearch from './components/term-search.vue';
import TrademarkSearch from './components/trademark-search.vue';
import './css/application.css';
import { Locales } from './locales/locales';

const i18n = createI18n({
  legacy: false,
  locale: 'es',
  fallbackLocale: 'es',
  messages: Locales.messages,
});

document.addEventListener('DOMContentLoaded', () => {
  const globalComponents = {
    BaseButton,
    BaseInput,
    BaseLabel,
    BaseMultiselect,
  };

  const app = createApp({
    components: {
      App,
      TermSearch,
      TrademarkSearch,
    },
  });

  Object.entries(globalComponents).forEach(([name, component]) => {
    app.component(name, component);
  });

  app.use(i18n);
  app.use(VueQueryPlugin);

  app.mount('#vue-app');

  return app;
});
