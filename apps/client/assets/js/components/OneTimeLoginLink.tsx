import * as React from 'react';
import { ReactNode } from 'react';
import { css, StyleSheet } from 'aphrodite';
import { Form, Header } from 'semantic-ui-react';
import * as Clipboard from 'clipboard';
import gql from 'graphql-tag';
import { ApolloQueryResult } from 'apollo-client';

const style = StyleSheet.create({
  container: {
    marginTop: 30,
    maxWidth: 300
  }
});

interface IProps {
}

interface IState {
  link?: string;
  loading?: boolean;
  clipboard?: Clipboard;
}


class _OneTimeLoginLink extends React.Component<IProps, IState> {
  constructor(props: IProps) {
    super(props);
    this.state = {};
  }

  public componentDidMount() {
    const clipboard = new Clipboard("#link-cp-trigger", {
      text: (_target: Element): string => {
        const ele = document.getElementById("link-cp-target") as HTMLInputElement;
        return ele.value;
      }
    });
    this.setState({ clipboard });
  }

  public render() {
    return (
      <div className={css(style.container)}>
        <Form>
          <Header>One-time login link</Header>

          <p>
            Generate a one-time login link for passwordless authentication. This link is valid
            for only 24 hours.
          </p>

          {this.renderGeneratedLink()}

          <Form.Button
            type="button"
            primary={true}
            fluid={true}
            onClick={this.generate}
            loading={this.state.loading}
          >
            Generate
          </Form.Button>
        </Form>
      </div>
    );
  }

  private renderGeneratedLink = (): ReactNode | null => {
    if (this.state.link) {
      return (
        <Form.Input
          readOnly={true}
          value={this.state.link}
          labelPosition="right"
          id="link-cp-target"
          action={{ icon: "copy", id: "link-cp-trigger", type: "button" }}
        />
      );
    } else {
      return null;
    }
  };

  private generate = () => {
    this.setState({ loading: true, link: null });

    const query = gql`
    {
      getOneTimeLoginLink
    }`;

    window.grapqlClient.query({ query: query }).then((response: ApolloQueryResult<{ getOneTimeLoginLink: string }>) => {
      const link = response.data.getOneTimeLoginLink;
      this.setState({ link: link, loading: false });
    }).catch(() => {
      this.setState({ loading: false });
      console.error('oh no');
    });
  }

  public componentWillUnmount() {
    if (this.state.clipboard) {
      this.state.clipboard.destroy();
    }
  }
}

export const OneTimeLoginLink = _OneTimeLoginLink;
