import * as React from 'react';
import { MainNav, ActiveItem } from './../components/MainNav';
import ChangePasswordForm from './../components/ChangePasswordForm';

export default class Settings extends React.Component {
  public render() {
    return (
      <div>
        <MainNav activeItem={ActiveItem.Settings}/>
        <ChangePasswordForm />
      </div>
    );
  }
}
