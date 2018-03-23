/* tslint:disable */
//  This file was automatically generated and should not be edited.

export interface GetAccountQueryVariables {
  id: string,
};

export interface GetAccountQuery {
  getAccount:  {
    name: string,
    id: string,
  } | null,
};

export interface DeleteAccountMutationVariables {
  id: string,
};

export interface DeleteAccountMutation {
  deleteAccount:  {
    id: string,
  } | null,
};

export interface GetAccountsQuery {
  getAccounts:  Array< {
    name: string,
    id: string,
  } | null > | null,
};
