module V1
  module ApiHelper
    shared_examples_for 'an endpoint' do
      it 'should return a 200 status' do
        expect(response.status).to eql(200)
        response.parse(j)
      end

      it 'should return a json object' do
        header = response.header['Content-Type']
        expect(header).to include('application/json')
      end
    end
  end
end
