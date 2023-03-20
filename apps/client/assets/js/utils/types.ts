export type IjustEvent = {
  id: string;
  name: string;
  count: number;
  insertedAt: string;
  updatedAt: string;
  ijustContextId: string;
};

export type IjustContext = {
  id: string;
  name: string;
  userId: string;
};
