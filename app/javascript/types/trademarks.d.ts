declare interface Trademark {
  trademarkName?: string;
  trademarkOffice?: string;
  applicationNumber?: string;
  applicationDate?: string;
  trademarkStatus?: string;
  markImageUri?: string;
  detailImageUri?: string;
  trademarkStandardCode?: string;
  score?: number;
  niceClasses?: NiceClass[];
}
