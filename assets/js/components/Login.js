"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var __makeTemplateObject = (this && this.__makeTemplateObject) || function (cooked, raw) {
    if (Object.defineProperty) { Object.defineProperty(cooked, "raw", { value: raw }); } else { cooked.raw = raw; }
    return cooked;
};
exports.__esModule = true;
var React = require("react");
var aphrodite_1 = require("aphrodite");
var semantic_ui_react_1 = require("semantic-ui-react");
var apollo_client_1 = require("apollo-client");
var apollo_link_http_1 = require("apollo-link-http");
var apollo_cache_inmemory_1 = require("apollo-cache-inmemory");
var graphql_tag_1 = require("graphql-tag");
var client = new apollo_client_1.ApolloClient({
    // By default, this client will send queries to the
    //  `/graphql` endpoint on the same host
    link: new apollo_link_http_1.HttpLink(),
    cache: new apollo_cache_inmemory_1.InMemoryCache()
});
var styles = aphrodite_1.StyleSheet.create({
    container: {
        border: '1px solid #ccc',
        width: '300px',
        padding: '10px',
        position: 'absolute',
        top: 'calc(50% - 150px)',
        right: 'calc(50% - 150px)',
        background: 'black'
    },
    header: {
        fontSize: '1.1rem',
        marginBottom: '40px'
    },
    inputLast: {
        marginTop: '20px'
    },
    submit: {
        marginTop: '40px'
    },
    signup: {
        fontSize: '0.875rem',
        display: 'flex',
        justifyContent: 'center',
        marginTop: '20px'
    }
});
var Login = /** @class */ (function (_super) {
    __extends(Login, _super);
    function Login(props) {
        var _this = _super.call(this, props) || this;
        _this.state = props;
        _this.passwordChanged = _this.passwordChanged.bind(_this);
        _this.usernameChanged = _this.usernameChanged.bind(_this);
        _this.submit = _this.submit.bind(_this);
        return _this;
    }
    Login.prototype.usernameChanged = function (event, data) {
        var username = data.value;
        var newState = {
            username: username,
            canSubmit: this.validateInputs(username, this.state.password)
        };
        if (this.state.usernameIsInvalid && window.Utils.isValidEmail(username)) {
            newState.usernameIsInvalid = false;
        }
        this.setState(newState);
    };
    Login.prototype.passwordChanged = function (event, data) {
        var password = data.value;
        var newState = {
            password: password,
            canSubmit: this.validateInputs(this.state.username, password)
        };
        if (this.state.passwordIsInvalid && window.Utils.isValidPassword(password)) {
            newState.passwordIsInvalid = false;
        }
        this.setState(newState);
    };
    Login.prototype.validateInputs = function (username, password) {
        return window.Utils.isValidEmail(username) && window.Utils.isValidPassword(password);
    };
    Login.prototype.submit = function (event) {
        var query = graphql_tag_1["default"](templateObject_1 || (templateObject_1 = __makeTemplateObject(["\n    query {\n      login(email: \"", "\", password: \"", "\") {\n        token\n      }\n    }"], ["\n    query {\n      login(email: \"", "\", password: \"", "\") {\n        token\n      }\n    }"])), this.state.username, this.state.password);
        client.query({ query: query }).then(console.log);
        var isValid = true;
        if (!window.Utils.isValidEmail(this.state.username)) {
            this.setState({ usernameIsInvalid: true });
            isValid = false;
        }
        if (!window.Utils.isValidPassword(this.state.password)) {
            this.setState({ passwordIsInvalid: true });
            isValid = false;
        }
        if (!isValid) {
            event.preventDefault();
            console.log('error yo');
        }
    };
    Login.prototype.render = function () {
        return (<semantic_ui_react_1.Form className={aphrodite_1.css(styles.container)}>
        <div className={aphrodite_1.css(styles.header)}>Login</div>
        <input type="hidden" name="_csrf_token" value={this.state.csrf_token}/>

        <semantic_ui_react_1.Form.Field>
          <label>Email</label>
          <semantic_ui_react_1.Input name="email" autoFocus={true} onChange={this.usernameChanged}/>
        </semantic_ui_react_1.Form.Field>

        <semantic_ui_react_1.Form.Field>
          <label>Password</label>
          <semantic_ui_react_1.Input type="password" name="password" onChange={this.passwordChanged}/>
        </semantic_ui_react_1.Form.Field>

        <semantic_ui_react_1.Button primary={true} active={true} fluid={true} onClick={this.submit} type="submit" className={aphrodite_1.css(styles.submit)}>
          Login
        </semantic_ui_react_1.Button>

        <a href="/signup" className={aphrodite_1.css(styles.signup)}>Or signup</a>
      </semantic_ui_react_1.Form>);
    };
    return Login;
}(React.Component));
exports["default"] = Login;
var templateObject_1;
