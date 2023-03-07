<script setup lang="ts">
import { computed, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import { useQuery } from '@tanstack/vue-query';

import { termApi } from '../api/term';

interface NiceClassWithTerms {
  id: number;
  shortDescription: string;
  terms: Term[];
}

const { t } = useI18n();

const search = ref('');
const classIdShowingDetails = ref(null as number | null);

const { data: terms, refetch, isError } = useQuery(
  ['terms', search.value],
  () => termApi.index(search.value),
  {
    refetchOnWindowFocus: false,
    enabled: false,
  },
);

const termsGroupedByClass = computed(() => (
  terms.value?.reduce((acc : Record<number, NiceClassWithTerms>, term : Term) => {
    if (acc[term.niceClassId]) {
      acc[term.niceClassId].terms.push(term);
    } else {
      acc[term.niceClassId] = {
        id: term.niceClassId,
        shortDescription: term.niceClass.shortDescription,
        terms: [term],
      };
    }

    return acc;
  },
  {})
));

</script>
<template>
  <div class="my-5 mx-auto w-1/2 rounded-lg border bg-slate-100 p-5">
    <div class="flex flex-col gap-5">
      <base-input
        v-model="search"
        :label="t('termSearch.searchLabel')"
        name="search"
        class="w-full"
      />
      <base-button
        @click="refetch"
      >
        {{ t('termSearch.search') }}
      </base-button>
    </div>
    <div
      v-if="isError"
    >
      <p>{{ t('termSearch.error') }}</p>
    </div>
    <div
      v-else-if="terms?.length > 0"
      class="mt-5"
    >
      <h2 class="mb-2 text-2xl font-bold">
        {{ t('termSearch.results') }}
      </h2>
      <div
        class="flex flex-col gap-5"
      >
        <div
          v-for="niceClassWithTerms in termsGroupedByClass"
          :key="niceClassWithTerms.id"
          class="flex w-full flex-col justify-between rounded-lg border bg-slate-200 p-1"
        >
          <div class="flex justify-between">
            <div class="flex w-11/12 flex-col">
              <h3 class="text-lg">
                {{ t('termSearch.classNumber') }} {{ niceClassWithTerms.id }}
              </h3>
              <p class="h-fit max-h-14 overflow-scroll text-sm">
                {{ niceClassWithTerms.shortDescription }}
              </p>
              <p class="mt-2 text-xs text-green-800">
                {{ t('termSearch.numberOfTerms') }}: {{ niceClassWithTerms.terms.length }}
              </p>
            </div>
            <div class="w-1/12">
              <button
                class="border bg-blue-200 p-2 text-xs"
                @click="classIdShowingDetails = niceClassWithTerms.id"
              >
                {{ t('termSearch.showDetails') }}
              </button>
            </div>
          </div>

          <div
            v-if="classIdShowingDetails == niceClassWithTerms.id"
            class="mx-2 mt-5 flex h-fit max-h-40 flex-col gap-3 overflow-scroll rounded border border-slate-400 p-2"
          >
            <p
              v-for="term in niceClassWithTerms.terms"
              :key="term.id"
              class="my-0 py-0 text-xs text-slate-700"
            >
              • {{ term.name }}
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
