import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Header, Form, Loader } from "semantic-ui-react";
import { compose } from "redux";
import { connect } from "react-redux";
import { Link } from "react-router-dom";
import { fetchAccounts } from "@store";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30
  },

  loaderContainer: {
    display: "flex",
    justifyContent: "center"
  },

  fetchError: {
    color: "red"
  }
});

class _AccountMembershipForm extends React.Component {
  componentWillMount() {
    this.props.fetchAccounts();
  }

  render() {
    return (
      <div className={css(style.container)}>
        <Form>
          <Header>Account membership</Header>
          <p>Change which accounts you belong to</p>

          {this.renderAccounts()}
        </Form>
      </div>
    );
  }

  renderAccounts = () => {
    if (this.props.isLoading) {
      return (
        <div className={css(style.loaderContainer)}>
          <Loader active inline />
        </div>
      );
    } else if (this.props.accountsFetchError) {
      return (
        <div className={css(style.fetchError)}>
          {this.props.accountsFetchError}
        </div>
      );
    } else if (
      this.props.accounts &&
      Object.getOwnPropertyNames(this.props.accounts).length !== 0
    ) {
      return (
        <div>
          {Object.keys(this.props.accounts).map(id => (
            <div key={id}>
              <Link to={`accounts/${id}`}>{this.props.accounts[id].name}</Link>
            </div>
          ))}
        </div>
      );
    } else {
      return <div />;
    }
  };
}

const mapStateToProps = state => ({
  isLoading: state.accounts.loadingAllAccounts,
  accounts: state.accounts.accounts,
  accountsFetchError: state.accounts.accountsFetchError
});

const mapDispatchToProps = dispatch => ({
  fetchAccounts: () => dispatch(fetchAccounts())
});

export const AccountMembershipForm = compose(
  connect(mapStateToProps, mapDispatchToProps)
)(_AccountMembershipForm);
