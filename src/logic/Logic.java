package logic;

import common.ConnectionTMDb;

/**
 * Created by Shadowsong on 15/3/16.
 */
public class Logic {

    private static String apiKey;


    public Logic() {
        ConnectionTMDb conn = new ConnectionTMDb();

    }

    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }
}
