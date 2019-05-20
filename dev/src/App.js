import React from 'react';
import { BrowserRouter } from 'react-router-dom';

import Header from './components/Header';
import Footer from './components/Footer';
import Config from './components/Config';

export default class App extends React.Component {
    render() {
        return (
            <BrowserRouter>
                <Header />

                <Config />

                <Footer />
            </BrowserRouter>
        );
    }
}
