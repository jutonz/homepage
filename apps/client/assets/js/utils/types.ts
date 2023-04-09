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
  insertedAt: string;
  updatedAt: string;
};

export type IjustOccurrence = {
  id: string;
  userId: string;
  insertedAt: string;
  updatedAt: string;
};

export type User = {
  id: string;
  email: string;
};

export type Team = {
  id: string;
  name: string;
};

export type GetCurrentUser = {
  getCurrentUser?: User;
};
