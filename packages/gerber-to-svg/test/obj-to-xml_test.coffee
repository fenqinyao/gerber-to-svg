# test suite for simple js object to xml string
objToXml = require '../src/obj-to-xml'

describe 'object to xml function', ->
  it 'should return an empty string for an empty object', ->
    result = objToXml {}
    result.should.eql ''

  it 'should take the first, highest key and make that the node name', ->
    result = objToXml { nodeName: {} }
    result.should.eql '<nodeName/>'

  it 'should take keys and values as attributes', ->
    result = objToXml { root: { id: 'root-id', color: 'gold' } }
    result.should.eql '<root id="root-id" color="gold"/>'

  it "has a special key '_' that represents children", ->
    result = objToXml { top: { id: 'an-id', _: { child: {} } } }
    result.should.eql '<top id="an-id"><child/></top>'

  it 'can take an array of children', ->
    result = objToXml {
      g: {
        id: 'id'
        _: [ { s: { x: 0, y: 0  } }, { s: { cx: 5, cy: 6, r: 2 } } ]
      }
    }
    result.should.eql '<g id="id"><s x="0" y="0"/><s cx="5" cy="6" r="2"/></g>'

  it 'should accept an array as input', ->
    result = objToXml [ { elem1: {} }, elem2: {} ]
    result.should.eql '<elem1/><elem2/>'

  describe 'pretty print', ->
    it 'should take a pretty key to put nodes on new lines', ->
      obj = [ { node1: {} }, { node2: {} } ]
      opt = { pretty: true }
      (objToXml obj, opt).should.eql '<node1/>\n<node2/>'
    it 'pretty should default to two space tabs', ->
      obj = { parent: { _: { child: { _: { grandchild: {} } } } } }
      opt = { pretty: true }
      (objToXml obj, opt).should.eql """
        <parent>
          <child>
            <grandchild/>
          </child>
        </parent>
      """
    it 'pretty can take whatever through', ->
      obj = { parent: { _: { child: { _: { grandchild: {} } } } } }
      opt = { pretty: '\t' }
      (objToXml obj, opt).should
        .eql '<parent>\n\t<child>\n\t\t<grandchild/>\n\t</child>\n</parent>'

      obj = { p: { _: [ { c1: { _: [{ g1: {} }, { g2: {} }] } }, { c2: {} }] } }
      opt = { pretty: '    ' }
      (objToXml obj, opt).should.eql """
        <p>
            <c1>
                <g1/>
                <g2/>
            </c1>
            <c2/>
        </p>
      """
