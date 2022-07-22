import React, { useState, useEffect } from "react";
//import { compose } from "redux";
//import { connect } from "react-redux";
import { useHistory, useParams, useLocation } from "react-router-dom";
import { LoginForm } from "./../components/LoginForm";
import { BgGrid } from "./../BgGrid";
import gql from "graphql-tag";
import { useQuery } from 'urql'

const CHECK_SESSION_QUERY = gql`{ check_session }`

export function LoginRoute() {
  const location = useLocation();
  const history = useHistory();
  const params = useParams();
  const [_bgGrid, setBgGrid] = useState(null);
  const [{ data, fetching, error }] = useQuery({ query: CHECK_SESSION_QUERY });

  if (fetching) return null;
  if (error) return <div>An error occurred: {error.message}</div>;

  const isLoggedIn = data.check_session;

  useEffect(() => {
    if (isLoggedIn) {
      history.replace("/");
    } else {
      const newGrid = new BgGrid();
      newGrid.init();
      newGrid.start();
      setBgGrid(newGrid);
    }
  }, []);

  console.log('params', params)
  const onLogin = () => {
    const redirectTo = params.to;

    if (redirectTo) {
      window.location.replace(redirectTo);
    } else if (location.state.state) {
      history.replace(location.state);
    } else {
      window.location.replace("/");
    }
  }

  return (
    <div>
      <canvas id="gl-canvas">
        Your browser doesn't appear to support the
        <code>&lt;canvas&gt;</code> element.
      </canvas>

      <LoginForm onLogin={onLogin} />
    </div>
  );
}

//class _LoginRoute extends React.Component {
  //constructor(props) {
    //super(props);
    //this.state = { bgGrid: new BgGrid() };
  //}

  //componentDidMount() {
    //if (this.props.sessionAuthenticated) {
      //this.props.history.push("/");
    //} else {
      //this.state.bgGrid.init();
      //this.state.bgGrid.start();
    //}
  //}

  //render() {
    //return (
      //<div>
        //<canvas id="gl-canvas">
          //Your browser doesn't appear to support the
          //<code>&lt;canvas&gt;</code> element.
        //</canvas>

        //<LoginForm onLogin={this.onLogin} />
      //</div>
    //);
  //}

  //onLogin = () => {
    //this.props.initSession();
    //const query = new URLSearchParams(this.props.location.search);
    //const redirectTo = query.get("to");

    //if (redirectTo) {
      //window.location.replace(redirectTo);
    //} else if (this.props.location.state) {
      //this.props.history.push(this.props.location.state);
    //} else {
      //this.props.history.push("/");
    //}
  //};
//}

//const mapStoreToProps = (store) => ({
  //sessionAuthenticated: store.session.established,
//});

//const mapDispatchToProps = (dispatch) => ({
  //initSession: () =>
    //dispatch({ type: "SET_SESSION_ESTABLISHED", established: true }),
//});

//export const LoginRoute = compose(
  //withRouter,
  //connect(mapStoreToProps, mapDispatchToProps)
//)(_LoginRoute);
