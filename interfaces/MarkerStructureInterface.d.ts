interface MarkerStructureInterface {
    location: {
        latitude: number,
        longitude: number
    },
    status: MarkerStatusStructureInterface
}

interface MarkerStatusStructureInterface {
    batteryLevel: number,
    usbSlots: {
        total: number,
        available: number
    },
    roofed: boolean
}

export default MarkerStructureInterface