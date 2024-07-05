// -*- C++ -*-
// AID-GENERATED
// =========================================================================
// This class was generated by AID - Abstract Interface Definition          
// DO NOT MODIFY, but use the org.freehep.aid.Aid utility to regenerate it. 
// =========================================================================
#ifndef EVENT_CLUSTER_H
#define EVENT_CLUSTER_H 1

#include "EVENT/CalorimeterHit.h"
#include "EVENT/LCObject.h"
#include "EVENT/ParticleID.h"
#include "LCIOSTLTypes.h"
#include "empty_ignore.h"

namespace EVENT {


class Cluster ;
/**Vector of (pointers to) Clusters.*/
typedef std::vector<Cluster*> ClusterVec ;
/** The LCIO cluster.
 * 
 * @author gaede
 * @version $Id: Cluster.aid,v 1.14 2006-08-03 16:53:34 gaede Exp $
 */


class Cluster : public LCObject {

public: 
    /// Destructor.
    virtual ~Cluster() { /* nop */; }


    /** Useful typedef for template programming with LCIO */
    typedef Cluster lcobject_type ;

    /** Flagword that defines the type of cluster. Bits 0-15 can be used to denote the subdetectors
     *  that have contributed hits to the cluster. For the definition of the bits 
     *  check/Set the collection variables ClusterTypeBitNames and ClusterTypeBitIndices.
     *  </br>Bits 16-31 are used internally.
     */
    virtual int getType() const = 0;

    /** Energy of the cluster.
     */
    virtual float getEnergy() const = 0;

    /** Returns the error on the energy of the cluster.
     */
    virtual float getEnergyError() const = 0;

    /** Position of the cluster.
     */
    virtual const float* getPosition() const = 0;

    /** Covariance matrix of the position (6 Parameters)
    */
    virtual const FloatVec & getPositionError() const = 0;

    /** Intrinsic direction of cluster at position: Phi.
     * Not to be confused with direction cluster is seen from IP.
     */
    virtual float getIPhi() const = 0;

    /** Intrinsic direction of cluster at position: Theta.
     * Not to be confused with direction cluster is seen from IP.
     */
    virtual float getITheta() const = 0;

    /** Covariance matrix of the direction (3 Parameters). Stored as lower triangle matrix where
     * the order of parameters is: iPhi, iTheta. So we have cov(iPhi,iPhi), cov( iPhi, iTheta), 
     *  cov( iTheta, iTheta).
     */
    virtual const FloatVec & getDirectionError() const = 0;

    /** Shape parameters - check/set  collection parameter
     *  ClusterShapeParameters for size and names of parameters.
     */
    virtual const FloatVec & getShape() const = 0;

    /** The particle Id's sorted by their likelihood.
     * @see ParticleID
     */
    virtual const ParticleIDVec & getParticleIDs() const = 0;

    /** The clusters that have been combined to this cluster.
     */
    virtual const ClusterVec & getClusters() const = 0;

    /** The hits that have been combined to this cluster.
     *  Only available if collection flag bit LCIO::CLBIT_HITS==1 and if 
     *  the CalorimeterHit objects have not been saved with LCIO::RCHBIT_NO_PTR==1.
     *  @see CalorimeterHit
     */
    virtual const CalorimeterHitVec & getCalorimeterHits() const = 0;

    /** Returns the energy contribution of the hits 
     *  Runs parallel to the CalorimeterHitVec from getCalorimeterHits()
     */
    virtual const FloatVec & getHitContributions() const = 0;

    /** A vector that holds the energy observed in a particular subdetectors.
     *  The mapping of indices to subdetectors is implementation dependent.
     *  To be used as convenient information or if hits are not stored in 
     *  the data set, e.g. DST or FastMC. 
     *  Check/set collection parameter ClusterSubdetectorNames for decoding the
     *  indices of the array.
     */
    virtual const FloatVec & getSubdetectorEnergies() const = 0;
}; // class
} // namespace EVENT
#endif /* ifndef EVENT_CLUSTER_H */
