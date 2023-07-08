import { gql } from "urql";
import { cacheExchange } from "@urql/exchange-graphcache";

export const homepageCacheExchange = cacheExchange({
  keys: {
    Money: () => null,
  },
  updates: {
    Mutation: {
      createTeam(result, _args, cache, _info) {
        if (!result.createTeam) return;

        const query = gql`
          query {
            getTeams {
              id
              name
            }
          }
        `;

        cache.updateQuery({ query }, (data) => {
          data.getTeams.push(result.createTeam);
          return data;
        });
      },
      joinTeam(result, _args, cache, _info) {
        if (!result.joinTeam) return;

        const query = gql`
          query {
            getTeams {
              id
              name
            }
          }
        `;

        cache.updateQuery({ query }, (data) => {
          data.getTeams.push(result.joinTeam);
          return data;
        });
      },
      leaveTeam(result, _args, cache, _info) {
        if (!result.leaveTeam) return;

        const query = gql`
          query {
            getTeams {
              id
              name
            }
          }
        `;

        cache.updateQuery({ query }, (data) => {
          const getTeams = data.getTeams;
          data.getTeams = getTeams.filter(
            ({ id }) => id != (result.leaveTeam as any).id,
          );
          return data;
        });
      },
      deleteTeam(result, _args, cache, _info) {
        if (!result.deleteTeam) return;

        const query = gql`
          query {
            getTeams {
              id
              name
            }
          }
        `;

        cache.updateQuery({ query }, (data) => {
          const getTeams = data.getTeams;
          data.getTeams = getTeams.filter(
            ({ id }) => id != (result.deleteTeam as any).id,
          );
          return data;
        });
      },
      ijustAddOccurrenceToEvent(result, _args, cache, _info) {
        const query = gql`
          query ($contextId: ID!, $eventId: ID!) {
            getIjustContextEvent(contextId: $contextId, eventId: $eventId) {
              id
              ijustOccurrences {
                id
                insertedAt
                updatedAt
                isDeleted
              }
            }
          }
        `;

        const event = (result.ijustAddOccurrenceToEvent as any).ijustEvent;
        const variables = {
          eventId: event.id,
          contextId: event.ijustContextId,
        };

        cache.updateQuery({ query, variables }, (data) => {
          data.getIjustContextEvent.ijustOccurrences.push(
            result.ijustAddOccurrenceToEvent,
          );
          return data;
        });
      },
      ijustDeleteOccurrence(result, args, cache, _info) {
        const query = gql`
          query ($contextId: ID!, $eventId: ID!) {
            getIjustContextEvent(contextId: $contextId, eventId: $eventId) {
              id
              ijustOccurrences {
                id
                insertedAt
                updatedAt
                isDeleted
              }
            }
          }
        `;

        const eventId = (result.ijustDeleteOccurrence as any).ijustEventId;
        const contextId = cache.resolve(
          { __typename: "IjustEvent", id: eventId },
          "ijustContextId",
        );
        const variables = { contextId, eventId };

        cache.updateQuery({ query, variables }, (data) => {
          let occurrences = data.getIjustContextEvent.ijustOccurrences;
          occurrences = occurrences.filter(
            (o) => o.id !== args.ijustOccurrenceId,
          );
          data.getIjustContextEvent.ijustOccurrences = occurrences;
          return data;
        });
      },
      twitchChannelSubscribe(result, _args, cache, _info) {
        const query = gql`
          query {
            getTwitchChannels {
              id
            }
          }
        `;

        cache.updateQuery({ query }, (data) => {
          data.getTwitchChannels.push(result.twitchChannelSubscribe);
          return data;
        });
      },
      twitchChannelUnsubscribe(_result, args, cache, _info) {
        const query = gql`
          query {
            getTwitchChannels {
              name
            }
          }
        `;

        cache.updateQuery({ query }, (data) => {
          data.getTwitchChannels = data.getTwitchChannels.filter((channel) => {
            return channel.name !== args.name;
          });
          return data;
        });
      },
      twitchRemoveIntegration(_result, _args, cache, _info) {
        const query = gql`
          query {
            getTwitchUser {
              id
            }
          }
        `;

        cache.updateQuery({ query }, (data) => {
          data.getTwitchUser = null;
          return data;
        });
      },
    },
  },
});
