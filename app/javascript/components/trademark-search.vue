<script setup lang="ts">
import { defineProps, reactive, computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { useQuery } from '@tanstack/vue-query';

import { trademarkApi } from '../api/trademarks';

const { t } = useI18n();

const props = defineProps<{
  niceClasses: NiceClass[];
}>();

const niceClassOptions = computed(() => props.niceClasses.map((niceClass) => ({
  name: `Clase ${niceClass.number} - ${niceClass.shortDescription}`,
  id: niceClass.id,
})));

const search = reactive({
  name: '',
  niceClassIds: [] as NiceClass[],
});

const selectedClassIds = computed(() => search.niceClassIds.map((niceClass) => niceClass.id.toString()));

const { data: trademarks, refetch, isError } = useQuery(
  ['trademarks', search.name, selectedClassIds.value],
  () => trademarkApi.phoneticSearch(search.name, selectedClassIds.value),
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
        v-model="search.name"
        required
        :label="t('trademarkSearch.searchLabel')"
        name="name"
        class="w-full"
      />

      <base-multiselect
        v-model="search.niceClassIds"
        :options="niceClassOptions"
        :label-hint="t('trademarkSearch.niceClassHint')"
        :placeholder="t('trademarkSearch.niceClassPlaceholder')"
        searchable
        required
        name="niceClassIds"
      />

      <base-button
        @click="refetch"
      >
        {{ t('trademarkSearch.search') }}
      </base-button>
    </div>
    <div
      v-if="isError"
    >
      <p>{{ t('trademarkSearch.error') }}</p>
    </div>
    <div
      v-else-if="trademarks?.length > 0"
      class="mt-5"
    >
      <h2 class="mb-2 text-2xl font-bold">
        {{ t('trademarkSearch.results') }}
      </h2>

      <div
        v-for="trademark in trademarks"
        :key="trademark.applicationNumber"
        class="my-2 flex flex-col gap-5"
      >
        <div class="flex w-full flex-col justify-between rounded-lg border bg-slate-200 p-2">
          <div class="flex justify-between">
            <h3 class="text-lg">
              {{ trademark.trademarkName }}
            </h3>
            <div class="flex flex-col gap-1">
              <div class="flex gap-1">
                <span class="text-xs font-bold">
                  {{ t('trademarkSearch.applicationNumber') }}
                </span>
                <span class="text-xs">
                  {{ trademark.applicationNumber }}
                </span>
              </div>
            </div>
          </div>
          <div class="flex flex-col gap-1">
            <div class="flex gap-1">
              <span class="text-xs font-bold">
                {{ t('trademarkSearch.niceClass') }}:
              </span>
              <span class="text-xs">
                {{ trademark.niceClasses.join(', ') }}
              </span>
            </div>
          </div>

          <div class="flex flex-col gap-1">
            <div class="flex gap-1">
              <span class="text-xs font-bold">
                {{ t('trademarkSearch.trademarkStatus') }}:
              </span>
              <span class="text-xs">
                {{ t(`trademarkSearch.trademarkStatuses.${trademark.trademarkStatus}`) }}
              </span>
            </div>
          </div>

          <div class="flex flex-col gap-1">
            <div class="flex gap-1">
              <span class="text-xs font-bold">
                {{ t('trademarkSearch.score') }}:
              </span>
              <span class="text-xs">
                {{ trademark.score }}%
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
