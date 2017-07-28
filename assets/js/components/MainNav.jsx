import React from 'react';
import ReactDOM from 'react-dom';
import { StyleSheet, css } from 'aphrodite';

const styles = StyleSheet.create({
  mainNav: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'flex-end',
    height: '50px',
    width: '100hw'
  },

  navItem: {
    color: '#ccc',
    cursor: 'pointer',
    marginRight: '10px'
  },

  lastNavItem: {
    marginRight: '0'
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

export default MainNav;
