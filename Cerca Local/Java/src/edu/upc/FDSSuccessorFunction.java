package edu.upc;

import aima.search.framework.Successor;
import aima.search.framework.SuccessorFunction;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by marc.asenjo on 17/03/2016.
 */
public class FDSSuccessorFunction implements SuccessorFunction {

    protected static boolean debug = true;
    protected static boolean worstServer = false;

    public List getSuccessors(Object aState) {
        ArrayList<Successor> retVal = new ArrayList<>();
        FDS state = (FDS) aState;
        FDSHeuristicFunction heuristic = new FDSHeuristicFunction();

        int worst=state.getMaxTimeSid();
        for (int uid = 0; uid < state.getNUsers(); ++uid) {
            for (int rid = 0; rid < state.getNRequests(uid); ++rid) {
                int oldSid = state.getSid(uid, rid);
                if (!worstServer || worst==oldSid) {
                    for (int sid : FDS.getServers().fileLocations(state.getFid(uid, rid))) {
                        FDS newState = new FDS(state);
                        double v=-1;
                        long time=-1;
                        if (debug) {
                            v = heuristic.getHeuristicValue(newState);
                            time = newState.getTotalTime();
                        }
                        newState.swapServer(uid, rid, sid);
                        retVal.add(new Successor(debug ?
                                        "U" + uid + " -> F" + state.getFid(uid, rid) + " from S" +
                                        oldSid + " -> S" + sid + ": S=" + v + "ms T=" + time + "ms" : "",
                                newState));
                    }
                }
            }
        }

        return retVal;
    }
}
