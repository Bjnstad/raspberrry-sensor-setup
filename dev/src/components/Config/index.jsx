import React from 'react';
import FormControl from '@material-ui/core/FormControl';
import TextField from '@material-ui/core/TextField';
import Button from '@material-ui/core/Button';

export default class Config extends React.Component {

    constructor() {
        super();
        this.state = {ssid:"", psk: ""}
        this.handlePsk = this.handlePsk.bind(this);
        this.handleSsid = this.handleSsid.bind(this);
    }
    
    handlePsk(e) {
        
    }

    handleSsid(e) {
        this.setState({
            ssid: e.target.value
        });
    }

    handleSubmit(e) {
        e.preventDefault(); // Stop redirect
        const { ssid, psk } = this.state;

        fetch('127.0.0.1/cgi-bin/connect.cgi?ssid=' + ssid + '&psk=' + psk ).then(() => {
            window.location.replace("https://soilsense.no/register");
        }).catch(() => {
            window.location.replace("https://soilsense.no/register");
        });
    }

    render() {
        const { ssid, psk } = this.state;
        return (
            <div className="container" style={{marginTop: '60px'}}>
                <div className="row">
                    
                    <div className="col-6 offset-3">
                        <h1>
                            Connect your device to Wifi
                        </h1>
                    </div>

                </div>

                <div className="row">
                    
                    <div className="col-6 offset-3">
                        <FormControl>
                            <div className="row">
    
                                <div className="col-6">
                                    <TextField 
                                        style={{width: '100%'}}
                                        label="SSID"
                                        value={ssid}
                                        onChange={(e) => this.handleSsid(e)}
                                    />
                                </div>

                                <div className="col-6">
                                    <TextField 
                                        style={{width: '100%'}}
                                        label="Password"
                                        value={psk}
                                        onChange={(e) => this.handlePsk(e)}
                                    />
                                </div>
            
                                <div className="col-12" style={{textAlign:'right', marginTop: '15px'}}>
                                    <Button variant="contained" type="submit" onClick={(e) => this.handleSubmit(e)}>
                                        Connect
                                    </Button>
                                </div>
                            </div> 
                        </FormControl>
                    </div>

                </div>
            </div>
        );
    }
}
