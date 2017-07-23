import React from 'react';
import ReactDOM from 'react-dom';
import { StyleSheet, css } from 'aphrodite';

const styles = StyleSheet.create({
  mainNav: {
    display: 'flex',
    alignItems: 'center'
  },

  navItem: {
    color: '#ccc',
    cursor: 'pointer'
  },

  lastNavItem: {
    marginLeft: '10px'
  }
});

class MainNav extends React.Component {
  render() {
    return (
      <div className={css(styles.mainNav)}>
        <div className={css(styles.navItem)}>Home</div>
        <div className={css(styles.navItem, styles.lastNavItem)}>Login</div>
      </div>
    )
  }
}

ReactDOM.render(
  <MainNav/>,
  document.getElementById('main-nav')
);
