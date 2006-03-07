// $Id: lcio_swig.i,v 1.2 2006-02-27 17:59:09 jeremy Exp $

/*
 * SWIG interface file to make Python wrappers for LCIO.
 *
 * --Jeremy McCormick <jeremym@slac.stanford.edu>
*/

%module(docstring="Python wrapper for LCIO") lcio

%feature("autodoc", "1");

/* Ignore include guard symbols. */
%ignore EVENT_CLUSTER_H;
%ignore EVENT_LCCOLLECTION_H;
%ignore EVENT_LCEVENT_H;
%ignore EVENT_LCFLAG_H;
%ignore EVENT_LCFLOATVEC_H;
%ignore EVENT_LCGENERICOBJECTIMPL_H;
%ignore EVENT_LCGENERICOBJECT_H;
%ignore EVENT_LCINTVEC_H;
%ignore EVENT_LCOBJECT_H;
%ignore EVENT_LCPARAMETERSIMPL_H;
%ignore EVENT_LCPARAMETERS_H;
%ignore EVENT_LCRELATION_H;
%ignore EVENT_LCRUNHEADER_H;
%ignore EVENT_LCSTRVEC_H;
%ignore EVENT_LCWGTRELATIONIMPL_H;
%ignore EVENT_MCPARTICLE_H;
%ignore EVENT_PARTICLEID_H;
%ignore EVENT_RAWCALORIMETERHITIMPL_H;
%ignore EVENT_RAWCALORIMETERHIT_H;
%ignore EVENT_RECONSTRUCTEDPARTICLE_H;
%ignore EVENT_SIMCALORIMETERHIT_H;
%ignore EVENT_SIMTRACKERHIT_H;
%ignore EVENT_TPCHIT_H;
%ignore EVENT_TRACKERDATA_H;
%ignore EVENT_TRACKERHIT_H;
%ignore EVENT_TRACKERPULSE_H;
%ignore EVENT_TRACKERRAWDATA_H;
%ignore EVENT_TRACK_H;
%ignore EVENT_LCEVENTIMPL_H;
%ignore EVENT_RUNHEADERIMPL_H;
%ignore IMPL_ACCESSCHECKED_H;
%ignore IMPL_CLUSTERIMPL_H;
%ignore IMPL_MCPARTICLEIMPL_H;
%ignore IMPL_PARTICLEIDIMPL_H;
%ignore IMPL_RECONSTRUCTEDPARTICLEIMPL_H;
%ignore IMPL_SIMCALORIMETERHITIMPL_H;
%ignore IMPL_SIMTRACKERHITIMPL_H;
%ignore IMPL_TPCHITIMPL_H;
%ignore IMPL_TRACKERHITIMPL_H;
%ignore IMPL_TRACKIMPL_H;
%ignore IMPL_TrackerDataImpl_H;
%ignore IMPL_TrackerPulseImpl_H;
%ignore IMPL_TrackerRawDataImpl_H;
%ignore EVENT_LCFLAGIMPL_H;
%ignore IOIMPL_LCFACTORY_H;
%ignore IO_ILCFACTORY_H;
%ignore IO_LCREADER_H;
%ignore IO_LCWRITER_H;
%ignore LCIO_EXCEPTION_H;
%ignore LCIO_NAMESPACE_H;
%ignore LCIO_STD_TYPES;

%{

/* Include stl headers. */
#include <stdexcept>
#include <iostream>
#include <string>
#include <vector>
#include <map>

%}

/* Handle C++ Exceptions from Python. */
%include "exception.i"

%exception {
    try {
       $action
    } catch (exception &e) {
        PyErr_SetString(PyExc_Exception, const_cast<char*>(e.what()));
        return NULL;
    }
}

/* SWIG STL wrappers. */
%import "std_iostream.i"
%import "std_string.i"
%import "std_map.i"
%import "std_vector.i"

/*
 *
 * typemaps for double[3] or double* <-> tuple
 *
 * http://www.swig.org/Doc1.3/Python.html#Python
 *
 * 26.9.4 Mapping Python tuples into small arrays
 *
 * This is only declared in the EVENT namespace.
 *
 * FIXME: It will cause problems if double* does not point to a 3-member array!
 *
*/

namespace EVENT
{
    /* Convert an input tuple into a double[3] */
    %typemap(in) double[3](double temp[3]) {
        int i;
        if ( PyTuple_Check($input)) {
           if ( !PyArg_ParseTuple($input, "ddd", temp, temp+1, temp+2)) {
               PyErr_SetString(PyExc_TypeError,"tuple must have 3 elements");
               return NULL;
           }
           $1 = &temp[0];
        }
        else {
            PyErr_SetString(PyExc_TypeError, "expected a tuple");
            return NULL;
        }
    }

    /* Convert an output double[3] into a tuple. */
    %typemap(out) double* (double* temp) {
        $result = PyTuple_New(3);

        for (int i = 0; i < 3; i++)
        {
          PyTuple_SetItem( $result,i,PyFloat_FromDouble( $1[i] ) );
        }
    }

    /* Convert an input tuple into a float[3] */
    %typemap(in) float[3](float temp[3]) {
        int i;
        if ( PyTuple_Check($input)) {
           if ( !PyArg_ParseTuple($input, "fff", temp, temp+1, temp+2)) {
               PyErr_SetString(PyExc_TypeError,"tuple must have 3 elements");
               return NULL;
           }
           $1 = &temp[0];
        }
        else {
            PyErr_SetString(PyExc_TypeError, "expected a tuple");
            return NULL;
        }
    }

    /* Convert an output float[3] into a tuple. */
    %typemap(out) float* (float* temp) {
        $result = PyTuple_New(3);

        for (int i = 0; i < 3; i++)
        {
            PyTuple_SetItem( $result,i,PyFloat_FromDouble( $1[i] ) );
        }
    }

}

%{

/*
 * Embed the single definition from LCIOTypes.h
 */
namespace EVENT
{
    typedef long long long64;
}

/*
 * All the LCIO headers we will need.
 */
#include "EVENT/LCObject.h"
#include "EVENT/LCIO.h"
#include "lcio.h"
#include "Exceptions.h"
#include "EVENT/LCFlag.h"
#include "LCIOSTLTypes.h"
#include "EVENT/LCParameters.h"
#include "EVENT/LCCollection.h"
#include "IMPL/AccessChecked.h"
#include "EVENT/LCGenericObject.h"
#include "EVENT/LCRelation.h"
#include "EVENT/MCParticle.h"
#include "EVENT/SimCalorimeterHit.h"
#include "EVENT/RawCalorimeterHit.h"
#include "EVENT/SimTrackerHit.h"
#include "EVENT/TPCHit.h"
#include "EVENT/TrackerData.h"
#include "EVENT/TrackerHit.h"
#include "EVENT/TrackerPulse.h"
#include "EVENT/TrackerRawData.h"
#include "EVENT/ParticleID.h"
#include "EVENT/Track.h"
#include "EVENT/Cluster.h"
#include "EVENT/ReconstructedParticle.h"
#include "IMPL/LCEventImpl.h"
#include "IMPL/LCRunHeaderImpl.h"
#include "IMPL/LCGenericObjectImpl.h"
#include "IMPL/LCParametersImpl.h"
#include "IMPL/LCRelationImpl.h"
#include "IMPL/MCParticleImpl.h"
#include "IMPL/SimCalorimeterHitImpl.h"
#include "IMPL/RawCalorimeterHitImpl.h"
#include "IMPL/SimTrackerHitImpl.h"
#include "IMPL/TPCHitImpl.h"
#include "IMPL/TrackerDataImpl.h"
#include "IMPL/TrackerHitImpl.h"
#include "IMPL/TrackerPulseImpl.h"
#include "IMPL/TrackerRawDataImpl.h"
#include "IMPL/ParticleIDImpl.h"
#include "IMPL/TrackImpl.h"
#include "IMPL/ClusterImpl.h"
#include "IMPL/ReconstructedParticleImpl.h"
#include "IMPL/LCCollectionVec.h" /* FIXME: ~LCCollection is causing Seg Fault. */
#include "IMPL/LCFlagImpl.h"

/* Namespaces to use. */
using namespace std;
using namespace EVENT;
using namespace IMPL;

/*
 * Define a wrapper to the LCCollection in order to return typed objects.
 * FIXME: Make this a proper proxy class.
 */
template <class Element>
class LCCollectionWrapper
{

public:

    LCCollectionWrapper(LCCollection* coll)
    {
        _coll = coll;
    }

    LCCollection* getLCCollection()
    {
        return _coll;
    }

    virtual int getNumberOfElements() const
    {
        return _coll->getNumberOfElements();
    }

    virtual const std::string &getTypeName() const
    {
        return _coll->getTypeName();
    }

    virtual Element getElementAt(int index) const
    {
        return dynamic_cast<Element> ( _coll->getElementAt(index) );
    }

    virtual Element get(int index) const
    {
        return dynamic_cast<Element> ( _coll->getElementAt(index) );
    }

    virtual int getFlag() const
    {
        return _coll->getFlag();
    }

    virtual bool isTransient () const
    {
        return _coll->isTransient();
    }

    virtual bool isDefault () const
    {
        return _coll->isDefault();
    }

    virtual bool isSubset () const
    {
        return _coll->isSubset();
    }

    virtual void addElement (LCObject *obj) throw (ReadOnlyException, std::exception )
    {
        _coll->addElement( obj );
    }

    virtual void removeElementAt (int i) throw (ReadOnlyException, std::exception )
    {
       _coll->removeElementAt( i );
    }

    virtual void setFlag (int flag)
    {
        _coll->setFlag( flag );
    }

    virtual const LCParameters& getParameters () const
    {
        return _coll->getParameters();
    }

    virtual LCParameters& parameters ()
    {
        return _coll->parameters();
    }

private:
    LCCollection* _coll;
};

/* Define some typedefs using the above wrapper. */
typedef LCCollectionWrapper<MCParticle*> MCParticleCollection;
typedef LCCollectionWrapper<SimCalorimeterHit*> SimCalorimeterHitCollection;
typedef LCCollectionWrapper<RawCalorimeterHit*> RawCalorimeterHitCollection;
typedef LCCollectionWrapper<SimTrackerHit*> SimTrackerHitCollection;
typedef LCCollectionWrapper<LCGenericObject*> LCGenericObjectCollection;
typedef LCCollectionWrapper<TPCHit*> TPCHitCollection;
typedef LCCollectionWrapper<TrackerPulse*> TrackerPulseCollection;
typedef LCCollectionWrapper<ParticleID*> ParticleIDCollection;
typedef LCCollectionWrapper<Track*> TrackCollection;
typedef LCCollectionWrapper<Cluster*> ClusterCollection;
typedef LCCollectionWrapper<ReconstructedParticle*> ReconstructedParticleCollection;
typedef LCCollectionWrapper<LCRelation*> LCRelationCollection;

%}

/* Parse LCObject before the EVENT classes. */
%include "EVENT/LCObject.h"

/* Fiddle with EVENT/LCIO.h instead of using include. */
namespace EVENT
{
    class LCIO
    {
        public:

/*
 * Make all of the LCIO class's constants immutable.
 * FIXME: These are only immutable in lcio.cvar, not lcio.LCIO!
 */
%immutable;
            static const int CHBIT_LONG;
            static const int CHBIT_BARREL;
            static const int CHBIT_ID1;
            static const int CHBIT_PDG;
            static const int RCHBIT_LONG;
            static const int RCHBIT_BARREL;
            static const int RCHBIT_ID1;
            static const int RCHBIT_NO_PTR;
            static const int RCHBIT_TIME;
            static const int TRAWBIT_ID1;
            static const int THBIT_BARREL;
            static const int THBIT_MOMENTUM;
            static const int TRBIT_HITS;
            static const int CLBIT_HITS;
            static const int TPCBIT_RAW;
            static const int TPCBIT_NO_PTR;
            static const int LCREL_WEIGHTED;
            static const int GOBIT_FIXED;
            static const int READ_ONLY;
            static const int UPDATE;
            static const int ERROR;
            static const int SUCCESS;
            static const int WRITE_NEW;
            static const int WRITE_APPEND;

            /*
             * The static char* constants need to be defined here,
             * because we need to allocate the correct amount of space
             * for each one in the wrapping stage.  Otherwise, a Seg
             * Fault occurs at runtime.  Including LCIO.h doesn't seem to
             * do this correctly.
            */
            static const char* LCEVENT = "LCEvent";
            static const char* LCCOLLECTION = "LCCollection";
            static const char* LCRUNHEADER = "LCRunHeader";
            static const char* MCPARTICLE = "MCParticle";
            static const char* SIMCALORIMETERHIT = "SimCalorimeterHit";
            static const char* RAWCALORIMETERHIT = "RawCalorimeterHit";
            static const char* CALORIMETERHIT = "CalorimeterHit";
            static const char* SIMTRACKERHIT = "SimTrackerHit";
            static const char* TPCHIT = "TPCHit";
            static const char* TRACKERRAWDATA = "TrackerRawData";
            static const char* TRACKERDATA = "TrackerData";
            static const char* TRACKERPULSE = "TrackerPulse";
            static const char* TRACKERHIT = "TrackerHit";
            static const char* LCSTRVEC = "LCStrVec";
            static const char* LCFLOATVEC = "LCFloatVec";
            static const char* LCINTVEC = "LCIntVec";
            static const char* TRACK= "Track";
            static const char* CLUSTER = "Cluster";
            static const char* RECONSTRUCTEDPARTICLE = "ReconstructedParticle";
            static const char* LCRELATION = "LCRelation";
            static const char* LCGENERICOBJECT = "LCGenericObject";
%mutable;
    };
}

/*
 * Template instantiations for std::vector types.
 * These types are not interpretted correctly unless we do this.
 */

%template(FloatVec) std::vector< float >;
typedef std::vector< float > FloatVec;

%template(DoubleVec) std::vector< double >;
typedef std::vector< double > DoubleVec;

%template(ShortVec) std::vector< short >;
typedef std::vector< short > ShortVec;

%template(IntVec) std::vector< int >;
typedef std::vector< int > IntVec;

%template(StringVec) std::vector< string >;
typedef std::vector< string > StringVec;

%{

/* Include the LCIO headers that wrap std::vector. */
#include "EVENT/LCFloatVec.h"
#include "EVENT/LCStrVec.h"
#include "EVENT/LCIntVec.h"

%}

/* Parse the LCIO headers that wrap std::vector. */
%include "EVENT/LCFloatVec.h"
%include "EVENT/LCStrVec.h"
%include "EVENT/LCIntVec.h"

/* Template instantiations for other types based on std::vector. */
%template(_MCParticleVec) std::vector<EVENT::MCParticle*>;
%template(_LCObjectVec) std::vector<EVENT::LCObject*>;
%template(_ParticleIDVec) std::vector<EVENT::ParticleID*>;
%template(_ClusterVec) std::vector<EVENT::Cluster*>;
%template(_ReconstructedParticleVec) std::vector<EVENT::ReconstructedParticle*>;
%template(_TrackVec) std::vector<EVENT::Track*>;
%template(_CalorimeterHitVec) std::vector<EVENT::CalorimeterHit*>;

/*
 * Now parse the remaining LCIO headers in dependency order.
 * Some modifications and partial imports are performed,
 * depending on the particulars of the class.
 */
%include "Exceptions.h"
%include "EVENT/LCFlag.h"
%include "EVENT/LCParameters.h"
%include "EVENT/LCEvent.h"
%include "EVENT/LCRunHeader.h"
%include "IO/LCReader.h"
%include "IO/LCWriter.h"
%include "IO/ILCFactory.h"
%include "IOIMPL/LCFactory.h"
%include "lcio.h"
%include "IMPL/AccessChecked.h"
%include "EVENT/LCParameters.h"
%include "EVENT/LCCollection.h"
%include "EVENT/LCGenericObject.h"
%include "EVENT/LCParameters.h"
%include "EVENT/LCRelation.h"
%include "EVENT/MCParticle.h"
%include "EVENT/SimCalorimeterHit.h"
%include "EVENT/RawCalorimeterHit.h"
%include "EVENT/SimTrackerHit.h"
%include "EVENT/TPCHit.h"
%include "EVENT/TrackerData.h"
%include "EVENT/TrackerHit.h"
%include "EVENT/TrackerPulse.h"
%include "EVENT/TrackerRawData.h"
%include "EVENT/ParticleID.h"
%include "EVENT/Track.h"
%include "EVENT/Cluster.h"
%include "EVENT/ReconstructedParticle.h"
%include "IMPL/LCRunHeaderImpl.h"
%include "IMPL/LCEventImpl.h"
%include "IMPL/LCGenericObjectImpl.h"
%include "IMPL/LCParametersImpl.h"
%include "IMPL/LCRelationImpl.h"
%include "IMPL/MCParticleImpl.h"
%include "IMPL/SimCalorimeterHitImpl.h"
%include "IMPL/RawCalorimeterHitImpl.h"
%include "IMPL/SimTrackerHitImpl.h"
%include "IMPL/TPCHitImpl.h"
%include "IMPL/TrackerDataImpl.h"
%include "IMPL/TrackerHitImpl.h"
%include "IMPL/TrackerPulseImpl.h"
%include "IMPL/TrackerRawDataImpl.h"

/* Explicitly declare ParticleIDImpl to avoid warning messages about PIDSort. */
namespace IMPL
{
    class ParticleIDImpl : public EVENT::ParticleID, public AccessChecked
    {
        virtual int id();
        virtual int getType() const ;
        virtual int getPDG() const ;
        virtual float getLikelihood() const ;
        virtual  int getAlgorithmType() const ;
        virtual const EVENT::FloatVec & getParameters() const ;

        void setType( int type ) ;
        void setPDG( int pdg ) ;
        void setLikelihood( float logL ) ;
        void setAlgorithmType(int algorithmType ) ;
        void addParameter( float p ) ;
    };
}

%include "IMPL/TrackImpl.h"
%include "IMPL/ClusterImpl.h"
%include "IMPL/ReconstructedParticleImpl.h"

/*
 * Wrap LCCollectionVec, as default dtor will cause Seg Faults.
 */
/* FIXME: Removing dtor will cause memory leak. */
%nodefault;
namespace IMPL {
    class LCCollectionVec: public EVENT::LCCollection, public EVENT::LCObjectVec, public AccessChecked
    {
        public:
            LCCollectionVec (const std::string &type) ;
            virtual int getNumberOfElements() const ;
            virtual const std::string & getTypeName() const ;
            virtual EVENT::LCObject * getElementAt(int index) const ;
            virtual int getFlag() const ;
            virtual bool isTransient() const  ;
            void setTransient(bool val=true) ;
            virtual bool isDefault() const ;
            void setDefault(bool val=true) ;
            virtual bool isSubset() const ;
            void setSubset(bool val=true) ;
            void setFlag(int flag) ;
            virtual void addElement(EVENT::LCObject * obj) throw (EVENT::ReadOnlyException) ;
            virtual void removeElementAt(int i) throw (EVENT::ReadOnlyException) ;
            virtual const EVENT::LCParameters & getParameters() const;
            virtual EVENT::LCParameters & parameters();
    }; // class
} // namespace IMPL
%makedefault;

%include "IMPL/LCFlagImpl.h"

/* Declare the LCCollection wrapper. */
template <class Element>
class LCCollectionWrapper
{
public:
    LCCollectionWrapper(LCCollection* coll);
    LCCollection* getLCCollection();
    virtual int getNumberOfElements() const;
    virtual const std::string &getTypeName() const;
    virtual Element getElementAt(int index) const;
    virtual Element get(int index) const;
    virtual int getFlag() const;
    virtual bool isTransient () const;
    virtual bool isDefault () const;
    virtual bool isSubset () const;
    virtual void addElement (LCObject *obj) throw (ReadOnlyException, std::exception );
    virtual void removeElementAt (int i) throw (ReadOnlyException, std::exception );
    virtual void setFlag (int flag);
    virtual const LCParameters& getParameters () const;
    virtual LCParameters& parameters ();
private:
    LCCollection* _coll;
};

/*
 * Repeat the typedefs for the typed LCCollections and make template instantiations.
 */

%template(MCParticleCollection) LCCollectionWrapper<EVENT::MCParticle*>;
typedef LCCollectionWrapper<EVENT::MCParticle*> MCParticleCollection;

%template(SimCalorimeterHitCollection) LCCollectionWrapper<EVENT::SimCalorimeterHit*>;
typedef LCCollectionWrapper<EVENT::SimCalorimeterHit*> SimCalorimeterHitCollection;

%template(SimTrackerHitCollection) LCCollectionWrapper<EVENT::SimTrackerHit*>;
typedef LCCollectionWrapper<EVENT::SimTrackerHit*> SimTrackerHitCollection;

%template(LCGenericObjectCollection) LCCollectionWrapper<EVENT::LCGenericObject*>;
typedef LCCollectionWrapper<EVENT::LCGenericObject*> LCGenericObjectCollection;

%template(TPCHitCollection) LCCollectionWrapper<EVENT::TPCHit*>;
typedef LCCollectionWrapper<TPCHit*> TPCHitCollection;

%template(TrackerPulseCollection) LCCollectionWrapper<EVENT::TrackerPulse*>;
typedef LCCollectionWrapper<TrackerPulse*> TrackerPulseCollection;

%template(ParticleIDCollection) LCCollectionWrapper<EVENT::ParticleID*>;
typedef LCCollectionWrapper<ParticleID*> ParticleIDCollection;

%template(TrackCollection) LCCollectionWrapper<EVENT::Track*>;
typedef LCCollectionWrapper<Track*> TrackCollection;

%template(ClusterCollection) LCCollectionWrapper<EVENT::Cluster*>;
typedef LCCollectionWrapper<Cluster*> ClusterCollection;

%template(ReconstructedParticleCollection) LCCollectionWrapper<EVENT::ReconstructedParticle*>;
typedef LCCollectionWrapper<ReconstructedParticle*> ReconstructedParticleCollection;

%template(LCRelationCollection) LCCollectionWrapper<EVENT::LCRelation*>;
typedef LCCollectionWrapper<LCRelation*> LCRelationCollection;

/* Add functions to LCEvent for returning typed collections. */
%extend(python) EVENT::LCEvent {

    MCParticleCollection* getMCParticleCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            MCParticleCollection* coll = new MCParticleCollection( lccoll );
            return coll;
        }
        return 0;
    }

    SimCalorimeterHitCollection* getSimCalorimeterHitCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            SimCalorimeterHitCollection* coll = new SimCalorimeterHitCollection( lccoll );
           return coll;
        }
        return 0;
    }

    RawCalorimeterHitCollection* getRawCalorimeterHitCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            RawCalorimeterHitCollection* coll = new RawCalorimeterHitCollection( lccoll );
           return coll;
        }
        return 0;
    }

    SimTrackerHitCollection* getSimTrackerHitCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            SimTrackerHitCollection* coll = new SimTrackerHitCollection( lccoll );
            return coll;
        }
        return 0;
    }

    LCGenericObjectCollection* getLCGenericObjectCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            LCGenericObjectCollection* coll = new LCGenericObjectCollection( lccoll );
            return coll;
        }
        return 0;
    }

    TPCHitCollection* getTPCHitCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            TPCHitCollection* coll = new TPCHitCollection( lccoll );
            return coll;
        }
        return 0;
    }

    ParticleIDCollection* getParticleIDCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            ParticleIDCollection* coll = new ParticleIDCollection( lccoll );
            return coll;
        }
        return 0;
    }

    TrackCollection* getTrackCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            TrackCollection* coll = new TrackCollection( lccoll );
            return coll;
        }
        return 0;
    }

    ClusterCollection* getClusterCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            ClusterCollection* coll = new ClusterCollection( lccoll );
            return coll;
        }
        return 0;
    }

    ReconstructedParticleCollection* getReconstructedParticleCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            ReconstructedParticleCollection* coll = new ReconstructedParticleCollection( lccoll );
            return coll;
        }
        return 0;
    }

    LCRelationCollection* getLCRelationCollection(const std::string& name)
    {
        LCCollection* lccoll = self->getCollection(name);
        if ( 0 != lccoll ) {
            LCRelationCollection* coll = new LCRelationCollection( lccoll );
            return coll;
        }
        return 0;
    }
}