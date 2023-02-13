<script setup lang="ts">
import { useI18n } from 'vue-i18n';

const { t } = useI18n();

interface Props {
  label: string
  name: string
  required?: boolean
  labelHint?: string
}
defineProps<Props>();
</script>

<template>
  <label
    :for="name"
    class="mb-1 flex items-center whitespace-nowrap"
  >
    {{ label }}
    <span class="ml-2 text-sm text-slate-700">
      <template v-if="required && !labelHint">
        <span class="hidden lg:inline">{{ t('baseLabel.requiredLong') }}</span>
        <span class="inline lg:hidden">{{ t('baseLabel.requiredShort') }}</span>
      </template>
      {{ labelHint }}
    </span>
  </label>
</template>
