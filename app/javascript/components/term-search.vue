<script setup lang="ts">
import { ref } from 'vue';
import { useI18n } from 'vue-i18n';
import { useQuery } from '@tanstack/vue-query';

import { termApi } from '../api/term';

const { t } = useI18n();

const search = ref('');
const termIdShowingDetails = ref(null as number | null);

const { data: terms, refetch, isError } = useQuery(
  ['terms', search.value],
  () => termApi.index(search.value),
  {
    refetchOnWindowFocus: false,
    enabled: false,
  },
);

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
          v-for="term in terms"
          :key="term.id"
          class="flex w-full flex-col justify-between rounded-lg border bg-slate-200 p-1"
        >
          <div class="flex justify-between">
            <h3 class="text-lg">
              {{ term.name }}
            </h3>
            <div class="flex">
              <p class="mr-2">
                {{ t('termSearch.classNumber') }} {{ term.niceClass.number }}
              </p>
              <button
                class="border bg-blue-200 p-2 text-xs"
                @click="termIdShowingDetails = term.id"
              >
                {{ t('termSearch.showDetails') }}
              </button>
            </div>
          </div>
          <div v-if="termIdShowingDetails == term.id">
            <h4 class="text-lg">
              {{ t('termSearch.classNumber') }} {{ term.niceClassId }}
            </h4>
            <p> {{ term.niceClass.shortDescription }} </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
