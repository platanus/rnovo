import { api } from './index';

const BASE_PATH = '/api/internal/trademarks';

export const trademarkApi = {
  phoneticSearch(name: string, niceClassIds: string[]) {
    const path = `${BASE_PATH}/phonetic_search`;
    const params = {
      'trademark_name': name,
      'nice_class_ids': niceClassIds,
    };

    return api({
      method: 'get',
      url: path,
      params,
    }).then(res => res.data.trademarks);
  },
  FullPhoneticSearch(name: string, niceClassIds: string[]) {
    const path = `${BASE_PATH}/full_phonetic_search`;
    const params = {
      'trademark_name': name,
      'nice_class_ids': niceClassIds,
    };

    return api({
      method: 'get',
      url: path,
      params,
    }).then(res => res.data.trademarks);
  },
};
