import { api } from './index';

const BASE_PATH = '/api/internal/terms';

export const termApi = {
  index(name: string) {
    const path = `${BASE_PATH}?name=${name}`;

    return api({
      method: 'get',
      url: path,
    }).then(res => res.data.terms);
  },
};
